From: Paul Komkoff <i@stingr.net>
Subject: Re: kernel bug in file-item.c
Date: Thu, 30 Apr 2009 10:08:04 +0100
Message-ID: <715ea5c10904300208l5c0ac6f1ma07f96b662304c4a@mail.gmail.com>
References: <49F73F69.4010205@oel.state.nj.us>
	 <1240946633.15136.55.camel@think.oraclecorp.com>
	 <49F87A7F.7090804@oel.state.nj.us>
	 <1241027618.20099.48.camel@think.oraclecorp.com>
	 <49F89AB4.2090001@oel.state.nj.us>
	 <1241029841.20099.53.camel@think.oraclecorp.com>
	 <49F89E91.3020604@oel.state.nj.us>
	 <1241030419.20099.55.camel@think.oraclecorp.com>
	 <20090429193207.GK26602@tracyreed.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, mroconnor@oel.state.nj.us,
	linux-btrfs@vger.kernel.org
To: Tracy Reed <treed@ultraviolet.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090429193207.GK26602@tracyreed.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 29, 2009 at 8:32 PM, Tracy Reed <treed@ultraviolet.org> wrote:
> Note that this will be a problem that btrfs must properly manage. And
> it must be done MUCH better than a certain previously semi-popular
> filesystem did. The expectation needs to be set that due to the much

I don't think it's workable or feasible or whatever.
As soon as you have faulty memory or CPU, all bets are off.
-- 
This message represents the official view of the voices in my head
