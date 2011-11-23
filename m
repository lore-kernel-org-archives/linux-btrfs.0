From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: fsck with "err is 1"
Date: Wed, 23 Nov 2011 18:44:36 +0100
Message-ID: <4ECD3104.3050205@jan-o-sch.net>
References: <ByQ7Wl$y1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Helmut Hullen <Hullen@t-online.de>, linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ByQ7Wl$y1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 23.11.2011 18:32, Helmut Hullen wrote:
> One big problem of btrfs seems to be: you can't see on which partition/ 
> disk the defect sector (or something else) may be

A recent kernel (3.2, still rc) will tell you the byte number when an
error occurs, and also give the the opportunity to resolve this address
to all files affected.

-Jan
