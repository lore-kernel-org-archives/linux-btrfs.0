Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45621 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751770AbaBJRBZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 12:01:25 -0500
Message-ID: <52F90677.90107@fb.com>
Date: Mon, 10 Feb 2014 12:03:51 -0500
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
CC: Jeff Mahoney <jeffm@suse.com>, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 3/4][RFC] btrfs: export global block reserve size as space_info
References: <cover.1391779611.git.dsterba@suse.cz> <21dfbfe3b1361092ad1dc286f636c1fff4a2a4f6.1391779611.git.dsterba@suse.cz>
In-Reply-To: <21dfbfe3b1361092ad1dc286f636c1fff4a2a4f6.1391779611.git.dsterba@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/07/2014 08:34 AM, David Sterba wrote:
> Introduce a block group type bit for a global reserve and fill the space
> info for SPACE_INFO ioctl. This should replace the newly added ioctl
> (01e219e8069516cdb98594d417b8bb8d906ed30d) to get just the 'size' part
> of the global reserve, while the actual usage can be now visible in the
> 'btrfs fi df' output during ENOSPC stress.
>
> The unpatched userspace tools will show the blockgroup as 'unknown'.
>

This wasn't in my rc2 pull because I wanted to sync up with Jeff on it. 
  I like the idea of combining this into SPACE_INFO, any objections?

-chris
