Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47020 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752395AbcK3QUQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 11:20:16 -0500
Date: Wed, 30 Nov 2016 17:20:10 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v2 02/14] btrfs-progs: check: introduce function to find
 dir_item
Message-ID: <20161130162010.GR12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
 <20160921031604.23334-3-quwenruo@cn.fujitsu.com>
 <20161102152151.GH12522@twin.jikos.cz>
 <cedc76f5-fadc-c6d0-b491-eb16ccc3e15a@cn.fujitsu.com>
 <20161107170523.GR12522@twin.jikos.cz>
 <405368c7-cbaf-92cd-02ec-45d87b843dbc@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <405368c7-cbaf-92cd-02ec-45d87b843dbc@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 08, 2016 at 09:45:54AM +0800, Qu Wenruo wrote:
> > Yes please. Third namespace for existing error bits is not a good
> > option. Move the I_ERR bits to start from 32 and use them in the low-mem
> > code that's been merged to devel.
> >
> Should I submit a separate fix or replace the patchset?

Separate patches please. The check patches are at the beginning of
devel and there are several cleanup patches on top of them so that would
probably cause too many merge conflicts.
