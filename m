Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:45825 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750894AbaH1VvP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Aug 2014 17:51:15 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Undelete files / directory
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <53FE1DB2.8040900@sysnux.pf>
Date: Thu, 28 Aug 2014 15:51:13 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <4934565B-6B58-4ADA-BA16-50EC5D170F37@colorremedies.com>
References: <53FE1DB2.8040900@sysnux.pf>
To: Jean-Denis Girard <jd.girard@sysnux.pf>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 27, 2014, at 12:04 PM, Jean-Denis Girard <jd.girard@sysnux.pf> wrote:

> I'm on Fedora 20, with kernel 3.15.10-200.fc20.x86_64, and
> btrfs-progs-3.14.2-3.fc20.x86_64.

Ahh yes. So you'll see here that there's a new build for you not yet in updates repo.

http://koji.fedoraproject.org/koji/buildinfo?buildID=571861

Go here and click on the download link
x86_64	(build logs)
btrfs-progs-3.16-1.fc20.x86_64.rpm (info) (download)

You can apply it one of two ways:
yum install <downloadURL>

Or you can download the RPM to a local folder (curl -Os or whatever) and do:
yum install *rpm



Chris Murphy

