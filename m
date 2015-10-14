Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33607 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbbJNOkt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 10:40:49 -0400
Message-ID: <561E6969.40500@oracle.com>
Date: Wed, 14 Oct 2015 22:40:41 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Dmitry Katsubo <dmitry.katsubo@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Recover btrfs volume which can only be mounded in read-only mode
References: <CAOGcOQE3_ROtk=2kQkjTUkGE1tz=HEzbeZnrWUOPziW=kNNXBQ@mail.gmail.com>
In-Reply-To: <CAOGcOQE3_ROtk=2kQkjTUkGE1tz=HEzbeZnrWUOPziW=kNNXBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> # mount -o degraded /var
> Oct 11 18:20:15 kernel: BTRFS: too many missing devices, writeable
> mount is not allowed
>
> # mount -o degraded,ro /var
> # btrfs device add /dev/sdd1 /var
> ERROR: error adding the device '/dev/sdd1' - Read-only file system
>
> Now I am stuck: I cannot add device to the volume to satisfy raid pre-requisite.

  This is a known issue. Would you be able to test below set of patches
  and update us..

    [PATCH 0/5] Btrfs: Per-chunk degradable check

Thanks, Anand
