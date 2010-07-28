From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: Re: A device dedicated for metadata?
Date: Wed, 28 Jul 2010 21:14:28 +0800
Message-ID: <20100728131428.GA2664@laptop.jp.oracle.com>
References: <AANLkTik3Mrf+vY6qW6TTtGEghm48ma8tjiWYGfcLhhMq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: wks1986 <wks1986@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTik3Mrf+vY6qW6TTtGEghm48ma8tjiWYGfcLhhMq@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a question to your requirement:

If the meta is stored on the SSD and not on other HDDs, I think the SSD is must
to be "online" whenever you mount any of the HDDs. And in other words, without
the SSD, other HDDs are meaningless. Is that acceptable?

regards,
wengang.
On 10-07-28 17:32, wks1986 wrote:
> Hello
> 
> Recently I am learning about the Btrfs.
> 
> My requirement is to construct a cross-device btrfs volume consisting
> of a single SSD and many (much larger) HDDs.  The tricky part is that
> I want the SSD to be dedicated to metadata since SSDs are much faster
> (and more expensive) than HDDs and metadata are much more frequently
> queried than data.  And I do not want ordinary data to use up the
> precious space on the SSD in case there would be no room for metadata.
> 
> I have figured out that I can keep the metadata stored inside the
> first device by applying the "-m single" option to mkfs.btrfs.
> However, I do not know how to require that data should NOT be
> allocated on the SSD.  I read the mkfs code.  It appears to me that it
> can be worked around by excluding the SSD from the "raid group" for
> ordinary data.
> 
> A recent patch have been proposed to move "hot" (according to
> statistics) data to SSDs in order to improve performance.  My case is
> similar, but I know in advance that metadata are hotter.
> 
> I am not very confident about what I have found, so I need some
> comment.  Is it necessary to modify the Btrfs code?  On the other
> hand, I have not figured out exactly how much metadata there would be
> with a given amount of data.  How significant will it be to exclude
> ordinary data from the SSD?
> 
> Kunshan Wang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
