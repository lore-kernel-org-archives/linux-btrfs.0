Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:56331 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167Ab2HUBVo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Aug 2012 21:21:44 -0400
Message-ID: <5032E297.3050006@csamuel.org>
Date: Tue, 21 Aug 2012 11:21:27 +1000
From: Chris Samuel <chris@csamuel.org>
MIME-Version: 1.0
To: Curtis Jones <curtis.jones@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs and mdadm raid 6
References: <8AE790DA-04B5-4407-A5FE-D0AC4560B415@gmail.com> <20120820230603.1ba1afca@natsu> <2D811613-9EF6-4C5E-84A3-CB0E8D425B0B@gmail.com>
In-Reply-To: <2D811613-9EF6-4C5E-84A3-CB0E8D425B0B@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21/08/12 08:24, Curtis Jones wrote:

> You mentioned that btrfs was going to set aside a ton of space
> for metadata. Is that entirely due to going ext4 -> btrfs?

No, I believe that's a regression in btrfs in recent kernels..

-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
