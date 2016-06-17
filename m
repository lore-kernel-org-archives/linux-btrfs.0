Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34974 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161225AbcFQRRm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 13:17:42 -0400
Date: Fri, 17 Jun 2016 19:18:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Benedikt Morbach <benedikt.morbach@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] receive: strip root subvol path during process_clone
Message-ID: <20160617171807.GI4915@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160614225541.18140-1-benedikt.morbach@googlemail.com>
 <1465945606.18810.1.camel@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1465945606.18810.1.camel@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Wed, Jun 15, 2016 at 01:06:46AM +0200, Benedikt Morbach wrote:
> this fixes http://thread.gmane.org/gmane.comp.file-systems.btrfs/56902 
> for me.
> I got to this via gdb + good old debug printf and tbh I'm not entirely
> clear about the semantics of process_clone, so some error handling
> might be missing here?

thanks for the fix. The mail thread holds enough information to
reproduce the issue, I'll get to that on Monday. I'm not sure about the
use of strstr to match the subvolume name so I want to write the tests
first and craft some paths to see how it works.
