Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:35876 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755348Ab3ANPZP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jan 2013 10:25:15 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: kernel call trace when deleting a huge file (which used all the space) with btrfs
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAPVzhpw6rc9VuSwhaPx8xhP02u-vAXoQW_1-odaTiyfcsQx0jw@mail.gmail.com>
Date: Mon, 14 Jan 2013 08:25:13 -0700
Message-Id: <91D14518-E06D-43C4-A4AE-111560B5A91F@colorremedies.com>
References: <CAPVzhpw6rc9VuSwhaPx8xhP02u-vAXoQW_1-odaTiyfcsQx0jw@mail.gmail.com>
To: "linux-btrfs@vger.kernel.org BTRFS" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 14, 2013, at 12:11 AM, Reartes Guillermo <rtguille@gmail.com> wrote:

> 
> 
> Recently i have found some issues with BTRFS, i am using F18.


For list reference, Fedora 18 ships with btrfs-progs-0.20.rc1.20121017git91d9eec-1.fc18, and kernel-3.6.10-4.fc18.x86_64, which is what your bug report shows.

Is this reproducible with either kernel-3.7.2-201.fc18 or kernel-3.8.0-0.rc3.git0.1.fc19? Both are in koji.


Chris Murphy