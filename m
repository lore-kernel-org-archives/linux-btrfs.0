Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423552AbbFEPgL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Jun 2015 11:36:11 -0400
Date: Fri, 5 Jun 2015 17:36:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: avoid duplicate checks on user provided
 devid
Message-ID: <20150605153608.GS6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1433139918-820-1-git-send-email-anand.jain@oracle.com>
 <20150602151234.GH6761@twin.jikos.cz>
 <556EB19D.6010807@oracle.com>
 <556FC14E.1030700@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <556FC14E.1030700@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 04, 2015 at 11:09:02AM +0800, Anand Jain wrote:
>   Kindly do not integrated this patch as of now.
>   As I have just found that, the error reporting when
>   the default background option is used is not completely
>   transparent. I need to fix this before this patch.

Understood, thanks for the notice.
