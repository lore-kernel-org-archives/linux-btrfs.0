From: wfp5p@viridian.itc.virginia.edu (Bill Pemberton)
Subject: Re: assertion failures
Date: Fri, 26 Feb 2010 15:44:26 -0500 (EST)
Message-ID: <20100226204426.3341D40974@viridian.itc.virginia.edu>
References: <93cdabd21002261111v211e77e6ic789a2487461a420@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com (Chris Mason), linux-btrfs@vger.kernel.org
To: mfedyk@mikefedyk.com (Mike Fedyk)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <93cdabd21002261111v211e77e6ic789a2487461a420@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> 
> I wonder if the barrier messages are making it to this write back
> cache.  Do you see any messages about barriers in your kernel logs?
> 

None relating to the array.  The only barrier messages I see are for
filesystems on the servers internal disks.


-- 
Bill

