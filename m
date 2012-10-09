Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51129 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab2JIHNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2012 03:13:45 -0400
Received: by mail-vc0-f174.google.com with SMTP id fo13so5898340vcb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Oct 2012 00:13:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50732ED1.9030005@gmx.net>
References: <CAK=A7Ef2jTckd216+EVmYZhiArMWZrnWxe2K_aAF2C7ZL3pDHw@mail.gmail.com>
 <5072CEB6.6030709@gmx.net> <CAK=A7Ee84dXpc4DenR7-Sn8UPG-qTiRRS0fdvRCWT+hF1bPaSQ@mail.gmail.com>
 <50732ED1.9030005@gmx.net>
From: =?ISO-8859-1?Q?matthieu_Barth=E9lemy?= <bonsouere@gmail.com>
Date: Tue, 9 Oct 2012 09:13:02 +0200
Message-ID: <CAK=A7Efzgu8pS0P_i=qK-Fqahb4KENBrV-Fq_FHKHDm-GxCBjA@mail.gmail.com>
Subject: Re: working quota example?
To: Arne Jansen <sensille@gmx.net>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 8, 2012 at 9:51 PM, Arne Jansen <sensille@gmx.net> wrote:
> On 10/08/12 21:31, matthieu Barthélemy wrote:
>
>>
>> Are there any plan to maybe get a better 'btrfs quota show' output?
>
> Definitely. The first priority was to get the kernel part running, when
> that is settled, we can improve the user mode part. There's also still
> some work to do to make the tracking qgroups more presentable.
>
Yes, and it seems to run well, I confirm that I was able to set a
quota on a test subvolume and have it trigger as expected.

But now I'm stuck again, though maybe the problem is as obvious as the
one that made me post first...
After having created a file that triggered a "quota exceeded" error, I
created a snapshot of my subvolume. No problem here.
Then I tried to remove the original 'big' test file :

rm: cannot remove `/btrfs/test/bigFile': Disk quota exceeded


I then tried to delete the snapshot subvol to see if it helped:

# ./btrfs sub delete /btrfs/test/.snap1/
Delete subvolume '/btrfs/test/.snap1'
# rm /btrfs/test/bigFile
rm: cannot remove `/btrfs/roger/bigFile': Disk quota exceeded

# ./btrfs qgroup show /btrfs/
0/257 1073725440 4096
0/261 1073725440 4096

261 was the snap that I just removed. Why is it still there?

No problem, let's remove it:
# ./btrfs qgroup destroy 0/261 /btrfs/

# rm /btrfs/test/bigFile
rm: cannot remove `/btrfs/test/bigFile': Disk quota exceeded

# ls -lsha /btrfs/test/
total 1.0G
   0 drwxr-xr-x 1 root root   14 Oct  9 09:00 .
4.0K drwxr-xr-x 1 root root   10 Oct  8 19:56 ..
1.0G -rw-r--r-- 1 root root 1.0G Oct  8 19:58 bigFile



I have to destroy my subvolume qgroup (0/257) to be able to 'rm' my
file.  Is this the expected behavior?
Of course I did something wrong again, but where?

Thanks for your help,
