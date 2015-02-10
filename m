Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15216 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751220AbbBJUMi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 15:12:38 -0500
Message-ID: <54DA662F.2060501@fb.com>
Date: Tue, 10 Feb 2015 15:12:31 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 09/16] Btrfs-progs: Introduce metadump_v2
References: <1423512199-16552-1-git-send-email-jbacik@fb.com> <1423512199-16552-10-git-send-email-jbacik@fb.com> <20150210191443.GD28877@twin.jikos.cz>
In-Reply-To: <20150210191443.GD28877@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/10/2015 02:14 PM, David Sterba wrote:
> On Mon, Feb 09, 2015 at 03:03:12PM -0500, Josef Bacik wrote:
>> The METADUMP super flag makes us skip doing the chunk tree reading which isn't
>> helpful for the new restore since we have a valid chunk tree.  But we still want
>> to have a way for the kernel to know that this is a metadump restore so it
>> doesn't do things like verify data checksums.
>
> BTW, the METADUMP superblock flag is not used in kernel.
>

It will be, I have a patch, going to send it as soon as I track down 
this enospc problem.  Thanks,

Josef
