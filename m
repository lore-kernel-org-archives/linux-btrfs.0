Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521Ab3DOQis (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 12:38:48 -0400
Message-ID: <516C2D15.5010407@redhat.com>
Date: Mon, 15 Apr 2013 11:38:45 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Jan Alexander Steffens <jan.steffens@gmail.com>
CC: Dan McGrath <danmcgrath.ca@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: No-op when called as fsck.btrfsck
References: <1366033629-25121-1-git-send-email-danmcgrath.ca@gmail.com> <1366033629-25121-2-git-send-email-danmcgrath.ca@gmail.com> <CAMQ-g0eYL7Ab0cETWJW66-9e_qzgRR+Kyd++kk4fzD1m464aZg@mail.gmail.com>
In-Reply-To: <CAMQ-g0eYL7Ab0cETWJW66-9e_qzgRR+Kyd++kk4fzD1m464aZg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/15/13 9:03 AM, Jan Alexander Steffens wrote:
> On Mon, Apr 15, 2013 at 3:47 PM, Dan McGrath <danmcgrath.ca@gmail.com> wrote:
>> As per FAQ: It is safe to and recommended to turn fsck.btrfs into a no-op
>>
>> Signed-off-by: Dan McGrath <danmcgrath.ca@gmail.com>
>> ---
>>  btrfs.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/btrfs.c b/btrfs.c
>> index 691adef..78161a9 100644
>> --- a/btrfs.c
>> +++ b/btrfs.c
>> @@ -272,6 +272,8 @@ int main(int argc, char **argv)
>>
>>         if (!strcmp(bname, "btrfsck")) {
>>                 argv[0] = "check";
>> +       } else if (!strcmp(bname, "fsck.btrfsck")) {
>> +               exit(0);
>>         } else {
>>                 argc--;
>>                 argv++;
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Shouldn't it be fsck.btrfs, not fsck.btrfsck?
> 
> Also, fsck.xfs does a bit more than just an exit(0), maybe there's
> some merit to what it does. It's a simple shellscript, so check it
> out.

Yup I think the idea for xfs was that if called by initscripts w/ common
initscript options, be nice and quiet, but if it looks like it was invoked
by someone expecting something to happen, be more informative.

Git blame of the shell script is at 
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfsprogs.git;a=blame;f=fsck/xfs_fsck.sh;h=c5a96e688b994c36d9ab1b0206225f2f5e7b12e8;hb=HEAD
- it hasn't changed in forever but you might get some hints at why
it does what it does.

Expecting fsck.$FS in initscripts is just a leftover from pre-journaling-fs
days, I think.

-Eric

