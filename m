Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:33439 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab2ITMe2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 08:34:28 -0400
Date: Thu, 20 Sep 2012 14:34:19 +0200
From: David Sterba <dave@jikos.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs + Btrfs-progs:  make pipe functions re-usable
Message-ID: <20120920123419.GL17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5052C5A0.4090803@oracle.com>
 <20120914110432.GE17430@twin.jikos.cz>
 <5056AB8A.6000500@oracle.com>
 <20120917145957.GQ17430@twin.jikos.cz>
 <505807A9.8060401@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <505807A9.8060401@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 18, 2012 at 01:33:29PM +0800, Anand Jain wrote:
>   'btrfs service history <mnt>|<dev>'
>  is basically to show the list of cli/gui commands which are
>  successfully run on the btrfs as part of its -
>  creation (may be), configuration and maintenance.

Is it modelled after ZFS 'zpool history' command? AFAICS it captures
actions modifiying the pools, there's nothing similar for btrfs.

david
