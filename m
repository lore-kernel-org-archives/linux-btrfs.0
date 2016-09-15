Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:36746 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755629AbcIOLhU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 07:37:20 -0400
Received: by mail-it0-f67.google.com with SMTP id n143so4214912ita.3
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 04:37:19 -0700 (PDT)
Subject: Re: [RFC] Preliminary BTRFS Encryption
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
Cc: clm@fb.com, dsterba@suse.cz
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <bce627a8-7dcc-71f6-dd44-0444f7993725@gmail.com>
Date: Thu, 15 Sep 2016 07:37:13 -0400
MIME-Version: 1.0
In-Reply-To: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-13 09:39, Anand Jain wrote:
>
> This patchset adds btrfs encryption support.
>
> The main objective of this series is to have bugs fixed and stability.
> I have verified with fstests to confirm that there is no regression.
>
> A design write-up is coming next, however here below is the quick example
> on the cli usage. Please try out, let me know if I have missed something.
>
> Also would like to mention that a review from the security experts is due,
> which is important and I believe those review comments can be accommodated
> without major changes from here.
>
> Also yes, thanks for the emails, I hear, per file encryption and inline
> with vfs layer is also important, which is wip among other things in the
> list.
>
> As of now these patch set supports encryption on per subvolume, as
> managing properties on per subvolume is a kind of core to btrfs, which is
> easier for data center solution-ing, seamlessly persistent and easy to
> manage.
>
>
> Steps:
> -----
>
> Make sure following kernel TFMs are compiled in.
> # cat /proc/crypto | egrep 'cbc\(aes\)|ctr\(aes\)'
> name         : ctr(aes)
> name         : cbc(aes)
>
> Create encrypted subvolume.
> # btrfs su create -e 'ctr(aes)' /btrfs/e1
> Create subvolume '/btrfs/e1'
> Passphrase:
> Again passphrase:
>
> A key is created and its hash is updated into the subvolume item,
> and then added to the system keyctl.
> # btrfs su show /btrfs/e1 | egrep -i encrypt
> 	Encryption: 		ctr(aes)@btrfs:75197c8e (594790215)
>
> # keyctl show 594790215
> Keyring
>  594790215 --alsw-v      0     0  logon: btrfs:75197c8e
>
>
> Now any file data extents under the subvol /btrfs/e1 will be
> encrypted.
>
> You may revoke key using keyctl or btrfs(8) as below.
> # btrfs su encrypt -k out /btrfs/e1
>
> # btrfs su show /btrfs/e1 | egrep -i encrypt
> 	Encryption: 		ctr(aes)@btrfs:75197c8e (Required key not available)
>
> # keyctl show 594790215
> Keyring
> Unable to dump key: Key has been revoked
>
> As the key hash is updated, If you provide wrong passphrase in the next
> key in, it won't add key to the system. So we have key verification
> from the day1.
>
> # btrfs su encrypt -k in /btrfs/e1
> Passphrase:
> Again passphrase:
> ERROR: failed to set attribute 'btrfs.encrypt' to 'ctr(aes)@btrfs:75197c8e' : Key was rejected by service
>
> ERROR: key set failed: Key was rejected by service
>
> # btrfs su encrypt -k in /btrfs/e1
> Passphrase:
> Again passphrase:
> key for '/btrfs/e1' has  logged in with keytag 'btrfs:75197c8e'
>
> Now if you revoke the key the read / write fails with key error.
>
> # md5sum /btrfs/e1/2k-test-file
> 8c9fbc69125ebe84569a5c1ca088cb14  /btrfs/e1/2k-test-file
>
> # btrfs su encrypt -k out /btrfs/e1
>
> # md5sum /btrfs/e1/2k-test-file
> md5sum: /btrfs/e1/2k-test-file: Key has been revoked
>
> # cp /tfs/1k-test-file /btrfs/e1/
> cp: cannot create regular file ‘/btrfs/e1/1k-test-file’: Key has been revoked
>
> Plain text memory scratches for security reason is pending. As there are some
> key revoke notification challenges to coincide with encryption context switch,
> which I do believe should be fixed in the due course, but is not a roadblock
> at this stage.
>
Before I make any other comments, I should state that I asbolutely agree 
with Alex Elsayed about the issues with using CBC or CTR mode, and not 
supporting AE or AEAD modes.  If that's going to be the case, then 
there's essentially no point in merging this as is, as it has worse 
security than other filesystem level encryption options in the kernel by 
a pretty significant margin.  This absolutely _needs_ to be done right 
the first time, otherwise the reputation of BTRFS will suffer further, 
and nobody sane is going to use subvolume encryption for years after 
it's 'fixed' to be properly secure.

Now, the other thing I wanted to comment about:
How does this handle cloning of extents?  Can extents be cloned across 
subvolume boundaries when one of the subvolumes is encrypted?  Can they 
be cloned within an encrypted subvolume?  What happens when you try to 
clone them in either case if it isn't supported?

