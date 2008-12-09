From: Chris Mason <chris.mason@oracle.com>
Subject: Re: New disk format pushed out
Date: Tue, 09 Dec 2008 07:23:34 -0500
Message-ID: <1228825414.27601.6.camel@think.oraclecorp.com>
References: <1228781596.3962.22.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1228781596.3962.22.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-12-08 at 19:13 -0500, Chris Mason wrote:
> Hello everyone,
> 
> I've pushed out most of the pending patches, including a few big disk
> format changes.  It includes Yan Zheng's super block duplication code
> (with a few small mods for performance) and all new data checksumming
> code.
> 

Yan Zheng noticed that I've broken the space balancing code, so people
using raid should not use this yet.

-chris


