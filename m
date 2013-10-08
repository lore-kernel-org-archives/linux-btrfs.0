Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab3JHQtz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Oct 2013 12:49:55 -0400
Date: Tue, 8 Oct 2013 18:49:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: Wang Shilong <wangshilong1991@gmail.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: calculate disk space that a subvol could
 free
Message-ID: <20131008164951.GC12986@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1380300329-9123-1-git-send-email-anand.jain@oracle.com>
 <1380468336-5170-1-git-send-email-anand.jain@oracle.com>
 <20131001133919.GE18291@twin.jikos.cz>
 <C56AFBE2-55D0-4E05-9903-5DD61E3C3D1A@gmail.com>
 <525220DC.2030403@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <525220DC.2030403@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 07, 2013 at 10:47:56AM +0800, Anand Jain wrote:
>   I was also thinking if this should be inside kernel
>   facilitated by a new ioctl? so that we avoid number
>   of search ioctl thats required.

I think so. And for the feature itself, it can be handy in case where
qgroups are not established.

david
