Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:53178 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752782AbaJYCle (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Oct 2014 22:41:34 -0400
Message-ID: <544B0DDC.1020102@pobox.com>
Date: Fri, 24 Oct 2014 19:41:32 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, Larkin Lowrey <llowrey@nuclearwinter.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Heavy nocow'd VM image fragmentation
References: <5449898B.4090708@nuclearwinter.com> <20141024114916.GI12554@merlins.org>
In-Reply-To: <20141024114916.GI12554@merlins.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/24/2014 04:49 AM, Marc MERLIN wrote:
> On Thu, Oct 23, 2014 at 06:04:43PM -0500, Larkin Lowrey wrote:
>> I have a 240GB VirtualBox vdi image that is showing heavy fragmentation
>> (filefrag). The file was created in a dir that was chattr +C'd, the file
>> was created via fallocate and the contents of the orignal image were
>> copied into the file via dd. I verified that the image was +C.
> To be honest, I have the same problem, and it's vexing:

If I understand correctly, when you take a snapshot the file goes into 
what I call "1COW" mode. The snapshot is pinning the old image into 
place and the new data has to go somewhere. One explainer said it was 
"on its head" but I suspect the fragmentation still ends up in the 
written segment.

Options may include transferring the VMs to a subvolume that you don't 
snapshot very often.

Doing backups by taking the snapshot, transfering it to backup, and then 
dropping it before you restart the virtual machine.

Honestly while autodefrag would be your enemy, I don't see a lot of 
harm/degradation in leaving the VM images on my drive all normal COW and 
doing the occasional defrag.

I could, of course, be wrong.

