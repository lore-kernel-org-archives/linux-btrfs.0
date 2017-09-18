Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37838 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752903AbdIROlh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 10:41:37 -0400
Date: Mon, 18 Sep 2017 16:40:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Remove misleading BCP 78 boilerplate
Message-ID: <20170918144005.GC29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170917235227.6452-1-nsteeves@gmail.com>
 <20170917235227.6452-3-nsteeves@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170917235227.6452-3-nsteeves@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 17, 2017 at 07:52:27PM -0400, Nicholas D Steeves wrote:
> BCP 78 applies to RFC 6234, but sha224-256.c is Simplified BSD.
> 
> This causes the following lintian error when building on Debian and
> Debian derivatives:
> 
>     E: btrfs-progs source: license-problem-non-free-RFC-BCP78
>        tests/sha224-256.c
> 
> Please consult the following email from debian-legal@lists.debian.org
> for more information:
> 
> https://lists.debian.org/debian-legal/2017/08/msg00004.html

Thanks, this looks like I've copied too much from the RFC and was not
aware of the BCP license issues. I believe the copyright notice(s) past
the line mentioning the filename(s) should be enough to satisfy the
licensing requirements and also the debian license checker.
