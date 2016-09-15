Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:35480 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934824AbcIOOYK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 10:24:10 -0400
Received: by mail-it0-f68.google.com with SMTP id e20so4601032itc.2
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 07:24:09 -0700 (PDT)
Subject: Re: [RFC] Preliminary BTRFS Encryption
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <bce627a8-7dcc-71f6-dd44-0444f7993725@gmail.com>
 <69c23d9b-c1be-41ba-1382-3505ba88fdf9@oracle.com>
Cc: clm@fb.com, dsterba@suse.cz
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ee07da59-9c9d-10f8-8cf5-6dc86a8e3eab@gmail.com>
Date: Thu, 15 Sep 2016 10:24:02 -0400
MIME-Version: 1.0
In-Reply-To: <69c23d9b-c1be-41ba-1382-3505ba88fdf9@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-15 10:06, Anand Jain wrote:
>
> Thanks for comments.
> Pls see inline as below.
>
> On 09/15/2016 07:37 PM, Austin S. Hemmelgarn wrote:
>> On 2016-09-13 09:39, Anand Jain wrote:
>>>
>>> This patchset adds btrfs encryption support.
>>>
>>> The main objective of this series is to have bugs fixed and stability.
>>> I have verified with fstests to confirm that there is no regression.
>>>
>>> A design write-up is coming next, however here below is the quick
>>> example
>>> on the cli usage. Please try out, let me know if I have missed
>>> something.
>>>
>>> Also would like to mention that a review from the security experts is
>>> due,
>>> which is important and I believe those review comments can be
>>> accommodated
>>> without major changes from here.
>>>
>>> Also yes, thanks for the emails, I hear, per file encryption and inline
>>> with vfs layer is also important, which is wip among other things in the
>>> list.
>>>
>>> As of now these patch set supports encryption on per subvolume, as
>>> managing properties on per subvolume is a kind of core to btrfs,
>>> which is
>>> easier for data center solution-ing, seamlessly persistent and easy to
>>> manage.
>>>
>>>
>>> Steps:
>>> -----
>>>
>>> Make sure following kernel TFMs are compiled in.
>>> # cat /proc/crypto | egrep 'cbc\(aes\)|ctr\(aes\)'
>>> name         : ctr(aes)
>>> name         : cbc(aes)
>>>
>>> Create encrypted subvolume.
>>> # btrfs su create -e 'ctr(aes)' /btrfs/e1
>>> Create subvolume '/btrfs/e1'
>>> Passphrase:
>>> Again passphrase:
>>>
>>> A key is created and its hash is updated into the subvolume item,
>>> and then added to the system keyctl.
>>> # btrfs su show /btrfs/e1 | egrep -i encrypt
>>>     Encryption:         ctr(aes)@btrfs:75197c8e (594790215)
>>>
>>> # keyctl show 594790215
>>> Keyring
>>>  594790215 --alsw-v      0     0  logon: btrfs:75197c8e
>>>
>>>
>>> Now any file data extents under the subvol /btrfs/e1 will be
>>> encrypted.
>>>
>>> You may revoke key using keyctl or btrfs(8) as below.
>>> # btrfs su encrypt -k out /btrfs/e1
>>>
>>> # btrfs su show /btrfs/e1 | egrep -i encrypt
>>>     Encryption:         ctr(aes)@btrfs:75197c8e (Required key not
>>> available)
>>>
>>> # keyctl show 594790215
>>> Keyring
>>> Unable to dump key: Key has been revoked
>>>
>>> As the key hash is updated, If you provide wrong passphrase in the next
>>> key in, it won't add key to the system. So we have key verification
>>> from the day1.
>>>
>>> # btrfs su encrypt -k in /btrfs/e1
>>> Passphrase:
>>> Again passphrase:
>>> ERROR: failed to set attribute 'btrfs.encrypt' to
>>> 'ctr(aes)@btrfs:75197c8e' : Key was rejected by service
>>>
>>> ERROR: key set failed: Key was rejected by service
>>>
>>> # btrfs su encrypt -k in /btrfs/e1
>>> Passphrase:
>>> Again passphrase:
>>> key for '/btrfs/e1' has  logged in with keytag 'btrfs:75197c8e'
>>>
>>> Now if you revoke the key the read / write fails with key error.
>>>
>>> # md5sum /btrfs/e1/2k-test-file
>>> 8c9fbc69125ebe84569a5c1ca088cb14  /btrfs/e1/2k-test-file
>>>
>>> # btrfs su encrypt -k out /btrfs/e1
>>>
>>> # md5sum /btrfs/e1/2k-test-file
>>> md5sum: /btrfs/e1/2k-test-file: Key has been revoked
>>>
>>> # cp /tfs/1k-test-file /btrfs/e1/
>>> cp: cannot create regular file ‘/btrfs/e1/1k-test-file’: Key has been
>>> revoked
>>>
>>> Plain text memory scratches for security reason is pending. As there
>>> are some
>>> key revoke notification challenges to coincide with encryption context
>>> switch,
>>> which I do believe should be fixed in the due course, but is not a
>>> roadblock
>>> at this stage.
>>>
>
>
>
>> Before I make any other comments, I should state that I asbolutely agree
>> with Alex Elsayed about the issues with using CBC or CTR mode, and not
>> supporting AE or AEAD modes.
>
>   Alex comments was quite detailed, I did reply to it.
>   Looks like you missed my reply to Alex's comments ?
I've been having issues with GMail delaying random e-mails for excessive 
amounts of time (hours sometimes), so I didn't see your reply before 
sending this.  Even so, I do want it on the record that I agree with him 
completely.
>
>> How does this handle cloning of extents?  Can extents be cloned across
>> subvolume boundaries when one of the subvolumes is encrypted?
>
>  Yes only if both the subvol keys match.
OK, that makes sense.
>
>> Can they
>> be cloned within an encrypted subvolume?
>
>  Yes. That's things as usual.
Glad to see that that still works.  Most people I know who do batch 
deduplication do so within subvolumes but not across them, so that still 
working with encrypted subvolumes is a good thing.
>
>> What happens when you try to
>> clone them in either case if it isn't supported?
>
>  Gets -EOPNOTSUPP.
That actually makes more sense than what my first thought for a return 
code was (-EINVAL).
