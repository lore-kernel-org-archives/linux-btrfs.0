Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65490 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801AbaFVQn5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jun 2014 12:43:57 -0400
Message-ID: <53A707BE.8020008@fb.com>
Date: Sun, 22 Jun 2014 09:43:42 -0700
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: New BTRFS kernel issues in 3.15.1-1-ARCH
References: <1551998.5rGUV05DNv@zafu>
In-Reply-To: <1551998.5rGUV05DNv@zafu>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/22/2014 02:32 AM, Swâmi Petaramesh wrote:
> Hello,
>
> Got this kernel issue today while rsyncing (backup) 2 BTRFS filesystems. I had
> never seen this on those disks before upgrading to kernel 3.15.1-1-ARCH a
> couple days ago...
>
> Both disks seem to be physically healthy AFAIK.
>

Will you sysrq+w next time this happens and capture that output?  The softlockup
stuff will often not capture other blocked tasks that could tell us who is
causing issues.  Thanks,

Josef
