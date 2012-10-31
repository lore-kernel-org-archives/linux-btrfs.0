Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:10911 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422754Ab2JaLhM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 07:37:12 -0400
Message-ID: <50910D68.4020406@giantdisaster.de>
Date: Wed, 31 Oct 2012 12:37:12 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 1/3] Btrfs-progs: move open_file_or_dir() to utils.c
References: <1337954838-10140-1-git-send-email-sbehrens@giantdisaster.de> <1337954838-10140-2-git-send-email-sbehrens@giantdisaster.de> <5090FE9D.6050907@oracle.com>
In-Reply-To: <5090FE9D.6050907@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 31 Oct 2012 18:34:05 +0800, Anand Jain wrote:
>  This is useful. Do you have something which can apply on the latest.

No. But your message is a good reminder to me to rebase and resend the
btrfs-progs patchset for the device stats support. It's already 5 month
old and was not integrated at that time. Now it's outdated and I need to
rework and resend it. The patch you mention is a part of the device
stats patchset.

If you need this "move open_file_or_dir() to utils.c" thing quickly (in
the next two weeks), please send such a patch yourself (but not like I
did it, Hugo was absolutely right to get upset when I was moving and
changing a function in one go
<http://www.spinics.net/lists/linux-btrfs/msg17067.html>).

Stefan

> 
> On 25/05/12 22:07, Stefan Behrens wrote:
>> This is a preparation step to add support for device stats. The
>> definition
>> of the function open_file_or_dir() is moved from common.c to utils.c in
>> order to be able to share some common code between scrub and the device
>> stats in the following step. That common code uses open_file_or_dir().
>> Since open_file_or_dir() makes use of the function dirfd(3), the required
>> XOPEN version was raised from 6 to 7.
>>
>> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
>> ---
>>   Makefile         |    4 ++--
>>   btrfsctl.c       |   28 ----------------------------
>>   cmds-balance.c   |    1 +
>>   cmds-inspect.c   |    1 +
>>   cmds-subvolume.c |    1 +
>>   commands.h       |    3 ---
>>   common.c         |   46 ----------------------------------------------
>>   utils.c          |   31 +++++++++++++++++++++++++++++--
>>   utils.h          |    3 +++
>>   9 files changed, 37 insertions(+), 81 deletions(-)

