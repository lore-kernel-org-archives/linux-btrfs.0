Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41577 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1168300AbcKAL2D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Nov 2016 07:28:03 -0400
Date: Tue, 1 Nov 2016 12:28:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] btrfs-progs: receive: Introduce option to exam
 and dump send stream
Message-ID: <20161101112800.GZ12522@suse.cz>
Reply-To: dsterba@suse.cz
References: <20160907002935.8539-1-quwenruo@cn.fujitsu.com>
 <20160907002935.8539-3-quwenruo@cn.fujitsu.com>
 <20160908094228.GK16983@twin.jikos.cz>
 <20160908095613.GL16983@twin.jikos.cz>
 <9e6d85ed-e9b7-0a7c-44d0-83f66f369692@cn.fujitsu.com>
 <20161018120749.GO11398@suse.cz>
 <ead991f8-710e-e865-7cdd-2a4390fec3dd@cn.fujitsu.com>
 <20161031173109.GT12522@twin.jikos.cz>
 <4fb4c7df-e0b5-3848-6dec-d2915f472699@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4fb4c7df-e0b5-3848-6dec-d2915f472699@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 01, 2016 at 09:10:09AM +0800, Qu Wenruo wrote:
> I'm just a little curious about the stream samples.
> Should I create a send-dump-test to include all these samples? Or put 
> them somewhere else?

Misc tests would be fine for now, as you did in the new patchset.
