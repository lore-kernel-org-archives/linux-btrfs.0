Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29681 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932163AbaBEBWN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Feb 2014 20:22:13 -0500
Message-ID: <52F1923D.8090306@fb.com>
Date: Tue, 4 Feb 2014 20:22:05 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Kai Krakow <hurikhan77+btrfs@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Are nocow files snapshot-aware
References: <mh08sa-5tp.ln1@hurikhan77.spdns.de>
In-Reply-To: <mh08sa-5tp.ln1@hurikhan77.spdns.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/04/2014 03:52 PM, Kai Krakow wrote:
> Hi!
>
> I'm curious... The whole snapshot thing on btrfs is based on its COW design.
> But you can make individual files and directory contents nocow by applying
> the C attribute on it using chattr. This is usually recommended for database
> files and VM images. So far, so good...
>
> But what happens to such files when they are part of a snapshot? Do they
> become duplicated during the snapshot? Do they become unshared (as a whole)
> when written to? Or when the the parent snapshot becomes deleted? Or maybe
> the nocow attribute is just ignored after a snapshot was taken?
>
> After all they are nocow and thus would be handled in another way when
> snapshotted.
>
When snapshotted nocow files fallback to normal cow behaviour. Thanks,

Josef
