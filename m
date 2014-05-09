Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42251 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756779AbaEIRWk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 13:22:40 -0400
Message-ID: <536D0ED3.2050602@fb.com>
Date: Fri, 9 May 2014 13:22:27 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Abbas <mickylmartin@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Sending incremental backup causes deadlock (3.14.3)
References: <CAKAA-n=_jMyWFbfcGvMsMDJg3t7VpRegDDDybEeQ5oxof8graA@mail.gmail.com>
In-Reply-To: <CAKAA-n=_jMyWFbfcGvMsMDJg3t7VpRegDDDybEeQ5oxof8graA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/09/2014 11:41 AM, Abbas wrote:
> Has anyone else experienced a deadlock while doing an incremental send
> / receive?
>
> # uname -r
> 3.14.3-1.el6.elrepo.x86_64
>
> # btrfs version
> Btrfs v3.14.1
>
> Initial send works well but sending incremental snapshots just HALTS:
>
> # btrfs send -vvvv -p test/snap-2014-05-09-13:29:04
> test/snap-2014-05-09-13:32:58 | btrfs receive -vvvv backup/test
> At subvol test/snap-2014-05-09-13:32:58
> At snapshot snap-2014-05-09-13:32:58
> receiving snapshot snap-2014-05-09-13:32:58
> uuid=8cde86f7-6ded-5046-a55c-3a0d40e7a2fc, ctransid=0
> parent_uuid=1a2a9dc2-c271-524f-bd01-b671da630446, parent_ctransid=0
> ...
>

Known problem, fixed in 3.15-rc1.  Thanks,

Josef

