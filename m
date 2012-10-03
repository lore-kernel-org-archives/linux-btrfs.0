Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail47.e.nsc.no ([193.213.115.47]:64342 "EHLO mail47.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab2JCWLE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Oct 2012 18:11:04 -0400
Received: from [10.0.0.22] (ti0036a380-dhcp1045.bb.online.no [85.164.250.26])
	by mail47.nsc.no (8.14.4/8.14.4) with ESMTP id q93MB0gg024637
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 4 Oct 2012 00:11:01 +0200 (MEST)
Message-ID: <506CB7F4.9040705@middelthun.no>
Date: Thu, 04 Oct 2012 00:11:00 +0200
From: =?ISO-8859-1?Q?=D8ystein_S=E6ttem_Middelthun?=
	<oystein@middelthun.no>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: tree root
References: <506C6934.5010904@middelthun.no> <CAKcLGm_Y9iomb2eroXULoQPiueA9Gpx_BcJ-MeFm6V+JraXUqA@mail.gmail.com>
In-Reply-To: <CAKcLGm_Y9iomb2eroXULoQPiueA9Gpx_BcJ-MeFm6V+JraXUqA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/03/2012 07:29 PM, Mitch Harder wrote:
> If you do not have a suitable backup for these files, please make an
> effort to do what you can with restore.  Some of the repair methods
> out there have a possibility to make the situation worse.

We are talking about something like 50TB, so there is just no way I have 
the available space on other disks for temporary storage.

So in effect you are saying that there are no other available options 
than a restore? If I understand correctly a feature along the lines of 
"mount -o tree_root=14102764707840 /dev/ /path/" would solve my problem.

The fs is unmountable because of a temporary loss of connection with an 
underlying disk controller, and I don't think the device has a lot of 
errors besides not being able to find the latest tree root.


-- 
Best regards
Øystein Middelthun
