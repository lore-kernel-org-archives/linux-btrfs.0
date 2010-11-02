From: Chris Samuel <chris@csamuel.org>
Subject: Re: btrfs benchmark with 2.6.37-rc1
Date: Tue, 02 Nov 2010 11:53:06 +1100
Message-ID: <4CCF60F2.9000902@csamuel.org>
References: <AANLkTinp=wsayqczkpDB-75MedEpC0Z49FqM2dyFGG4x@mail.gmail.com>	<AANLkTikxKZ4gwtPqfPFvkMh2FqVBHrUOA2UzW7Uf_pHi@mail.gmail.com> <AANLkTi=ZdhiH2RsEVx8EM6L6XApm2-dyeq_=t+Vuk8Ck@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Morten P.D. Stevens" <mstevens@imt-systems.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=ZdhiH2RsEVx8EM6L6XApm2-dyeq_=t+Vuk8Ck@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/11/10 02:12, Morten P.D. Stevens wrote:

> mkfs.btrfs /dev/sdb
> mount -t btrfs /dev/sdb /mnt/btrfs

It would be interesting to see if the space_cache mount option
makes any difference to your numbers.

It's commit 0af3d00bad38d3bb9912a60928ad0669f17bdb76.

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
