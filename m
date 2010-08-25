From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: 2.6.36-rc1 btrfs still unstable
Date: Wed, 25 Aug 2010 18:57:38 +0200
Message-ID: <201008251857.39585.johannes.hirte@fem.tu-ilmenau.de>
References: <1281948382.1888.7.camel@chotu> <20100816121658.GT3315@think> <7222A6B8ACA37D4AA1AC37810C43E8A80F5FC5BC@mail.corp.imt-systems.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: Chris Mason <chris.mason@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "Morten P.D. Stevens" <mstevens@imt-systems.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7222A6B8ACA37D4AA1AC37810C43E8A80F5FC5BC@mail.corp.imt-systems.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 16 August 2010 16:17:54 Morten P.D. Stevens wrote:
> Hi Chris,
> 
> the other big question is:
> 
> Is btrfs with 2.6.36 really rockstable and ready to use in productive environments?
> 
> Thanks
> 
> Morten

I don't think so. There is at least one checksum bug and ENOSPC problems are also still present.

regards,
  Johannes
