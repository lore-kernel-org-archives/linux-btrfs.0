Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:55503 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab2INLEi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 07:04:38 -0400
Date: Fri, 14 Sep 2012 13:04:32 +0200
From: David Sterba <dave@jikos.cz>
To: anand jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs + Btrfs-progs:  make pipe functions re-usable
Message-ID: <20120914110432.GE17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5052C5A0.4090803@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5052C5A0.4090803@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2012 at 01:50:24PM +0800, anand jain wrote:
>  btrfs send introduced a part of code to read kernel-data
>  from user-end using pipe. We need this part of code to be
>  useable outside of send sub-cmd, so that developing
>  service sub-cmd can use it.

What's 'service sub-cmd' please?


david
