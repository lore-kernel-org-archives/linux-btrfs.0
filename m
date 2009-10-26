From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfsck aborts after transid verify failed?
Date: Mon, 26 Oct 2009 18:41:04 +0900
Message-ID: <20091026094104.GG5564@think>
References: <4ADF1117.6020903@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: John Dong <jdong@ubuntu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ADF1117.6020903@ubuntu.com>
List-ID: <linux-btrfs.vger.kernel.org>

> On 10/21/2009 09:44 AM, Yan, Zheng wrote:
> >On Wed, Oct 21, 2009 at 9:21 PM, John Dong<jdong@ubuntu.com>  wrote:
> >>>  On Oct 21, 2009, at 3:47 AM, Yan, Zheng wrote:
> >>>>>
> >>>>>  Did you run btrfsck on mounted FS ?
> >>>>>
> >>>>>  Yan, Zheng
> >>>
> >>>  Yes, I did. I thought it was okay to do so?
> >No, btrfs doesn't support that.
> Whoops! My bad then!
> 
> BTW, the wiki still says
> 
> http://btrfs.wiki.kernel.org/index.php/Btrfsck:
> 
> Do a limited check of the FS extent trees. Can be run on mounted and
> unmounted FS.

Thanks!, I've updated the docs.

-chris

