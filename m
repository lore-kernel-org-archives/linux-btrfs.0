From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: TRIM + RAID Support?
Date: Wed, 05 May 2010 14:22:43 +0100
Message-ID: <1273065763.13390.10.camel@macbook.infradead.org>
References: <20100504.091210.25251.1@webmail21.vgs.untd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: josef@redhat.com, linux-btrfs@vger.kernel.org
To: Justin <yoosty69@netzero.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100504.091210.25251.1@webmail21.vgs.untd.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2010-05-04 at 16:12 +0000, Justin wrote:
> Awesome.

Which is more than we can say for your use of email. Please don't
top-post, and please don't use broken mail clients which omit the
correct References: and In-Reply-To: threading headers from replies,
thus disassociating your response from the thread it was supposed to be
part of.

> Has there been a lot of testing with RAID + TRIM setups?

Not so much that anyone else has shown any interest in these patches, or
even independently noticed and reported the bugs they fix:

http://git.infradead.org/users/dwmw2/btrfs-raid56.git/commitdiff/3885963f
http://git.infradead.org/users/dwmw2/btrfs-raid56.git/commitdiff/3de9680a

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

