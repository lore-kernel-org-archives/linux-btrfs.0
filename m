Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55945 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbaHOG3C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Aug 2014 02:29:02 -0400
Date: Thu, 14 Aug 2014 23:28:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Chris Mason <clm@fb.com>, jbacik@fb.com, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeff Mahoney <jeffm@suse.com>, fdmanana@suse.com
Subject: Re: [RFC v2 0/2] vfs / btrfs: add support for ustat()
Message-ID: <20140815062856.GA27487@infradead.org>
References: <1405546678-7846-1-git-send-email-mcgrof@do-not-panic.com>
 <20140717080301.GA14263@infradead.org>
 <20140717174940.GR10393@wotan.suse.de>
 <CAB=NE6WaQqp52MfZfjcShAUchj-1B+ZMsF1r6HabSiUxFLb7jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB=NE6WaQqp52MfZfjcShAUchj-1B+ZMsF1r6HabSiUxFLb7jQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 14, 2014 at 10:48:05PM -0400, Luis R. Rodriguez wrote:
> Any further advice? I'll submit a v3 for RFC with some small change
> for a fix for stress testing identified by Filipe Manana.

The advice is to stop setting different dev_t values for different
files in btrfs.

