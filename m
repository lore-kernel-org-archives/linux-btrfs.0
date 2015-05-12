Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54390 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454AbbELQRu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 May 2015 12:17:50 -0400
Date: Tue, 12 May 2015 18:17:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Lauri =?iso-8859-1?Q?V=F5sandi?= <lauri.vosandi@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: receive explicit parent support
Message-ID: <20150512161748.GF23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1430043165-20641-1-git-send-email-lauri.vosandi@gmail.com>
 <1431024839-13693-1-git-send-email-lauri.vosandi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1431024839-13693-1-git-send-email-lauri.vosandi@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 07, 2015 at 09:53:59PM +0300, Lauri Võsandi wrote:
> This patch adds command-line flag -p to btrfs receive
> which makes it possible to disable automatic parent
> search for incremental snapshots and use explicitly
> specified path instead. Works also with multiple
> incremental snapshots.

Can you please describe the usecase(s) in detail? I don't have a clear
picture at the moment and given that there are objections I'd like to be
sure that we can document the expected behaviour possibly with a list of
"do not do this".
