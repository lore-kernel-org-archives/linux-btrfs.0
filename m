Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbcFFGNn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jun 2016 02:13:43 -0400
Subject: Re: [PATCH 02/45] block: add REQ_OP definitions and helpers
To: mchristi@redhat.com, linux-f2fs-devel@lists.sourceforge.net,
        linux-ext4@vger.kernel.org, konrad.wilk@oracle.com,
        drbd-dev@lists.linbit.com, philipp.reisner@linbit.com,
        lars.ellenberg@linbit.com, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org, target-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com,
        ocfs2-devel@oss.oracle.com
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
 <1465155145-10812-3-git-send-email-mchristi@redhat.com>
From: Hannes Reinecke <hare@suse.de>
Message-ID: <57551493.5050300@suse.de>
Date: Mon, 6 Jun 2016 08:13:39 +0200
MIME-Version: 1.0
In-Reply-To: <1465155145-10812-3-git-send-email-mchristi@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/05/2016 09:31 PM, mchristi@redhat.com wrote:
> From: Mike Christie <mchristi@redhat.com>
> 
> The following patches separate the operation (WRITE, READ, DISCARD,
> etc) from the rq_flag_bits flags. This patch adds definitions for
> request/bio operations (REQ_OPs) and adds request/bio accessors to
> get/set the op.
> 
> In this patch the REQ_OPs match the REQ rq_flag_bits ones
> for compat reasons while all the code is converted to use the
> op accessors in the set. In the last patches the op will become a
> number and the accessors and helpers in this patch will be dropped
> or updated.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
