Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:34594 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932091AbeFTQo6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 12:44:58 -0400
From: Bart Van Assche <Bart.VanAssche@wdc.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        "nborisov@suse.com" <nborisov@suse.com>,
        "dsterba@suse.com" <dsterba@suse.com>, "clm@fb.com" <clm@fb.com>,
        "jeffm@suse.com" <jeffm@suse.com>, "jbacik@fb.com" <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Fix a C compliance issue
Date: Wed, 20 Jun 2018 16:44:54 +0000
Message-ID: <c8f558835c1a767e24c00b7c3508a48a4d886cc4.camel@wdc.com>
References: <20180615223659.32420-1-bart.vanassche@wdc.com>
         <838e73e8-e9b8-6075-1d69-79bc65c15b0c@suse.com>
         <20180618092633.GH24375@twin.jikos.cz>
         <14645aca-930b-2d7d-a7d6-6893f7cfcbbd@suse.com>
In-Reply-To: <14645aca-930b-2d7d-a7d6-6893f7cfcbbd@suse.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2018-06-18 at 12:31 +0300, Nikolay Borisov wrote:
> On 18.06.2018 12:26, David Sterba wrote:
> > On Sat, Jun 16, 2018 at 01:28:13PM +0300, Nikolay Borisov wrote:
> > > I'd rather not see more printk being added. Nothing prevents from having
> > > the fmt string being passed to pr_info.
> > 
> > So you mean to do
> > 
> > +	static const char fmt[] = "Btrfs loaded, crc32c=%s"
> > +	pr_info(fmt);
> 
> Pretty much, something along the lines of
> 
> pr_info(fmt, crc32c_impl).
> 
> printk requires having the KERN_INFO in the format string, which I see
> no point in doing, correct me if I'm wrong?

You should know that what you proposed doesn't compile because pr_info()
relies on string concatenation and hence requires that its first argument is
a string constant instead of a const char pointer. Anyway, I will rework this
patch such that it uses pr_info() instead of printk().

Bart.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
