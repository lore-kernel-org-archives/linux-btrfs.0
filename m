Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:32583 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759036Ab2HXOQP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 10:16:15 -0400
Message-ID: <50378C73.7040901@oracle.com>
Date: Fri, 24 Aug 2012 22:15:15 +0800
From: Jeff Liu <jeff.liu@oracle.com>
Reply-To: jeff.liu@oracle.com
MIME-Version: 1.0
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] btrfs-progs: snapshot diff function
References: <5020D84E.4010900@oracle.com> <CAHf9xvbMRyzXbhDtUUcqimA6+RCNCnvE=TtsU5k4PAGcnz3akQ@mail.gmail.com>
In-Reply-To: <CAHf9xvbMRyzXbhDtUUcqimA6+RCNCnvE=TtsU5k4PAGcnz3akQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alex,

Thanks for taking a look.

On 08/24/2012 09:09 PM, Alex Lyakas wrote:

> Hi Jeff,
> how do you see this snapshot-diff functionality vs the send/receive
> functionality that was recently added? I think that the binary stream
> that the send code produces, can be interpreted by printing out text
> messages, which will essentially give the same information (although
> much more detailed) as your snapshot-diff tool.

send/receive has not yet implemented when I working on this feature(back to the end of last year).
looks there really has some duplicate efforts.

Just as you said, the produced stream of send need to interpret to show readable info, if the binary stream is
became huge enough, maybe that will make some silly user crying like me :).
Also, it is mainly focus on backup purpose IMHO, please correct me if I missing something in this point.

The diff utility is designed to list any changes between two snapshots in a straightforward way consider the command interface,
it also can be improved to show the differences at a given time range.

But sure, send/receive is just awesome, if we can introduce a interpreted script which do same thing to
make end user's life easier, that would be fine.

Thanks,
-Jeff

> Apologies if I somehow misunderstood what your snapshot-diff code does.
> 
> Thanks,
> Alex.
> 
> 
> On Tue, Aug 7, 2012 at 11:56 AM, Jeff Liu <jeff.liu@oracle.com> wrote:
>> Hello,
>>
>> I've done a prototype implementation of snapshot diff utility many months ago.
>> It was originally meant to analyze the differences between two snapshots which are
>> inherited from the same subvolume/snapshot.
>>
>> Moreover, the upstream LXC userland tools has been released with a dedicated template
>> to create new containers combine with btrfs subvolume/snapshot create function, so this
>> path set might be useful if someone is suffering from a broken container guest(it was
>> cloned from a health one in previous but it does not work with some configurations now).
>> In this case, this feature could works as an assistant to help investigating the root
>> cause by listing those changed files from the snapshot that the container resides.
>>
>> This patch set works to three kinds of change for now.
>> - new_file: new created files at the destination snapshot.
>>
>> - removed_file: those files are still resides on source subvolume/snapshot but they have
>>                 been removed from the destination.
>>
>> - updated_file: files are resides on both subvolumes/snapshots, but they might be changed.
>>
>> Currently, the user could do diff business on any two subvolumes/snapshots, if the destination
>> snapshot is not inherited from the same subvolume/snapshot upon the source one, he must be
>> surprised by the results, so it's better to improve it with pre-check for that if possible.
>>
>> Another issue is,
>> - if we created some new files or updated some existing files under the source snapshot,
>>   they will be marked as REMOVED/UPDATED out of the source from the destination snapshot's
>>   point of view, so the results might looks a bit strange.
>>
>>
>> A quick demo:
>> root@kdev:/btrfs# btrfs subvolume diff-snapshot one two
>> [REMOVED REGFILE] one/regfile_in_one objectid 264 transid 50
>> [REMOVED DIR] one/dir_02_at_one objectid 262 transid 36
>> [REMOVED REGFILE] one/dir_02_at_one/file_at_dir02_one objectid 263 transid 37
>> [REMOVED DIR] one/dir_at_one objectid 258 transid 29
>> [REMOVED REGFILE] one/dir_at_one/file_02_at_one_dir objectid 260 transid 32
>> [REMOVED REGFILE] one/dir_at_one/file_03_at_one_dir objectid 261 transid 35
>> [REMOVED REGFILE] one/dir_at_one/file_at_one_dir objectid 259 transid 30
>> [REMOVED REGFILE] one/file_at_one objectid 257 transid 26
>> [NEW REGFILE] two/regfile_in_two objectid 265 transid 50
>> [NEW DIR] two/dir_at_two objectid 262 transid 40
>> [NEW REGFILE] two/dir_at_two/file01_at_dir_of_two objectid 263 transid 41
>> [NEW SYMLINK] two/dir_at_two/passwd objectid 264 transid 42
>> [NEW REGFILE] two/file_02 objectid 258 transid 23
>> [NEW REGFILE] two/file_03 objectid 270 transid 68
>> [NEW REGFILE] two/file_04 objectid 275 transid 68
>>
>>
>> Any comments are appreciated!
>>
>> Thanks,
>> -Jeff
>>
>>
>>  Makefile         |    2 +-
>>  btrfs-list.c     |    3 +-
>>  cmds-subvolume.c |   90 +++++
>>  diff-snapshot.c  | 1026 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  diff-snapshot.h  |   47 +++
>>  5 files changed, 1165 insertions(+), 3 deletions(-)
>>
>>
>>
>>
>>
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


