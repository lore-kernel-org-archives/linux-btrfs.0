Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61475 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab2H1R0X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Aug 2012 13:26:23 -0400
Received: by obbuo13 with SMTP id uo13so10982505obb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Aug 2012 10:26:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHf9xvbUk-KucXHOpKTrQrWMDuEqaYdU3Kz+aGSZOxxmDQcyvw@mail.gmail.com>
References: <5028D57F.5090803@robertbuhren.de>
	<1345463835-26636-1-git-send-email-list.btrfs@jan-o-sch.net>
	<5035EFDE.4090404@robertbuhren.de>
	<20120824133348.GY17430@twin.jikos.cz>
	<50388BBF.70903@robertbuhren.de>
	<CAHf9xvZ-VRx7yWZoqp-NMwzwmxHsjhBDS6agJfcY+3VcwjsA2g@mail.gmail.com>
	<503BBE5B.806@robertbuhren.de>
	<CAHf9xvbUk-KucXHOpKTrQrWMDuEqaYdU3Kz+aGSZOxxmDQcyvw@mail.gmail.com>
Date: Tue, 28 Aug 2012 20:26:22 +0300
Message-ID: <CAHf9xva-ARL_fhB6xS4_-f4KmuOF6wrajJ=HuVSmswLyz31Fdw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs-progs: replace find_mount_root from send code
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Robert Buhren <robert@robertbuhren.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Robert,
can you pls apply this patch. It should solve the issue (your script
now runs ok for me).

Alex.


diff --git a/cmds-receive.c b/cmds-receive.c
index a8be6fa..3ee2ff8 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -792,11 +792,18 @@ int do_receive(struct btrfs_receive *r, const
char *tomnt, int r_fd)
        int ret;
        int end = 0;

-       r->root_path = strdup(tomnt);
-       r->mnt_fd = open(tomnt, O_RDONLY | O_NOATIME);
+       r->root_path = realpath(tomnt, NULL);
+       if (!r->root_path) {
+               ret = -errno;
+               fprintf(stderr, "ERROR: realpath %s failed. "
+                               "%s\n", tomnt, strerror(-ret));
+               goto out;
+       }
+
+       r->mnt_fd = open(r->root_path, O_RDONLY | O_NOATIME);
        if (r->mnt_fd < 0) {
                ret = -errno;
-               fprintf(stderr, "ERROR: failed to open %s. %s\n", tomnt,
+               fprintf(stderr, "ERROR: failed to open %s. %s\n", r->root_path,
                                strerror(-ret));
                goto out;
        }








On Tue, Aug 28, 2012 at 11:27 AM, Alex Lyakas
<alex.bolshoy.btrfs@gmail.com> wrote:
> Thank you, Robert for the detailed data. I will debug & get back to
> you before Friday.
>
> Alex.
>
>
> On Mon, Aug 27, 2012 at 9:37 PM, Robert Buhren <robert@robertbuhren.de> wrote:
>> Hi Alex,
>>
>> i've made a list of all commands i executed for this test. You can find it
>> here:
>>
>> http://pastebin.com/y8PBgmMZ
>>
>>
>>
>>> Hi Robert,
>>> do you think you can make the "root_snap_send" file of yours available
>>> anywhere (not sure how big it is)?
>>
>> I'm afraid i've already delete it :/ sry. But in the pastebin there should
>> be all the commands
>> you need to execute to reproduce my setup.
>>
>>>
>>> Also, I am not sure I understand how you btrfs tree looks like WRT to
>>> where all subvolumes are mounted (but all others seem to understand
>>> well).
>>>
>>> You mentioned:
>>>>
>>>> /dev/loop0 on /mnt/TEST_ROOT type btrfs
>>>> (rw,relatime,compress=lzo,space_cache)  # default-subvolume
>>>> /dev/loop0 on /mnt/TEST_ROOT/root_volid0 type btrfs
>>>> (rw,relatime,compress=lzo,space_cache) # subvolid= 0
>>>> /dev/loop1 on /mnt/TEST_ROOT/backup_volid0 type btrfs
>>>> (rw,relatime,compress=lzo,space_cache)
>>>> btrfs subvolume snapshot -r /mnt/TEST_ROOT/root_volid0/root/
>>>> /mnt/TEST_ROOT/root_volid0/root_snap
>>>
>>> Are you trying to snapshot a directory here? I.e., what is "root"
>>> within "root_volid0"?
>>
>> root is a subvolume inside the /dev/loop0 fs. It is set as the default
>> subvolume.
>> I mounted /dev/loop0 at /mnt/TEST_ROOT and inside that i mounted /dev/loop0
>> again,
>> but this time with subvolid=0. So "/mnt/TEST_ROOT/root_volid0/root" is
>> actually a subvolume
>> which is also mounted at "/mnt/TEST_ROOT".
>>
>>> Can you pls list all subvolumes you have on your source filesystem
>>> (the one you are trying to backup), and where each one is mounted?
>>> Again, looks like I'm the only one confused about this, so apologies.
>>>
>>> You can also possibly use the "tree" utility to better visualize your
>>> fs tree, like:
>>> tree -A  --inodes --noreport /mnt/TEST_ROOT
>>>
>>> Jan, David, hope it's ok with you if I'll try to debug this.
>>>
>>> Thanks,
>>> Alex.
>>>
>> I'm kinda in a hurry now because i'm leaving for Holidays soon and i still
>> have to finish my bachelor thesis :P
>>
>> I hope with the the commands from the pastebin you have everything you need.
>> I can answer emails until Friday morning.
>>
>> Regards,
>>
>> Robert
>>
>>
>>
>>>
>>>
>>>
>>>
>>> On Sat, Aug 25, 2012 at 11:24 AM, Robert Buhren <robert@robertbuhren.de>
>>> wrote:
>>>>
>>>> On 24.08.2012 15:33, David Sterba wrote:
>>>>>
>>>>> On Thu, Aug 23, 2012 at 10:54:54AM +0200, Robert Buhren wrote:
>>>>>>
>>>>>> I'm on linux-3.6-rc2 and btrfs-progs from git.
>>>>>
>>>>> Please try it with Chris' for-linus branch, it contains a fair portion
>>>>> of send-related fixes and from brief look they may be related to the
>>>>> errors you see.
>>>>>
>>>>> david
>>>>
>>>> Hi David,
>>>>
>>>> i just tried it with a kernel from the "for-linus" branch. But i still
>>>> get
>>>> the same error.
>>>> Just to be sure:
>>>> You ment this branch:
>>>>
>>>> http://git.kernel.org/?p=linux/kernel/git/mason/linux-btrfs.git;a=shortlog;h=refs/heads/for-linus
>>>>
>>>> right?
>>>>
>>>>
>>>> Regards,
>>>>
>>>> Robert
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
