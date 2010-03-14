From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: SSD Optimizations
Date: Sat, 13 Mar 2010 19:19:01 -0800
Message-ID: <4B9C55A5.3090200@goop.org>
References: <4B97F7CE.4030405@bobich.net>	<4B9829B1.1020706@bobich.net>	<20100311073853.GA26129@attic.humilis.net>	<201003111159.58081.hka@qbs.com.pl>	<20100311123103.34246e95.skraw@ithnet.com>	<20100311143905.GA20569@attic.humilis.net>	<20100311183506.adce61ee.skraw@ithnet.com>	<20100311180017.GK6509@think> <20100313174359.ec81c8b7.skraw@ithnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>, sander@humilis.net,
	Hubert Kario <hka@qbs.com.pl>, linux-btrfs@vger.kernel.org,
	Gordan Bobic <gordan@bobich.net>
To: Stephan von Krawczynski <skraw@ithnet.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100313174359.ec81c8b7.skraw@ithnet.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/13/2010 08:43 AM, Stephan von Krawczynski wrote:
> - Nowadays: being a linux installation today chances are that the matrix has
> you. Quite a lot of installations are virtualized. So your storage is a virtual
> one either, which means it is likely being a fs buffer from the host system,
> i.e. RAM.
>    

That would be a strictly amateur-hour implementation.  It is very 
important for data integrity that at least all writes are synchronous, 
and ideally all IO should be uncached in the host.  In that case the 
performance of the guest's virtual IO device will be broadly similar to 
a real hardware device.

     J
