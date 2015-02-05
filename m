Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34023 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbbBEKkV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Feb 2015 05:40:21 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YJJr9-0000P7-50
	for linux-btrfs@vger.kernel.org; Thu, 05 Feb 2015 11:40:19 +0100
Received: from barriere.frankfurter-softwarefabrik.de ([217.11.197.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Feb 2015 11:40:19 +0100
Received: from lvml by barriere.frankfurter-softwarefabrik.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Feb 2015 11:40:19 +0100
To: linux-btrfs@vger.kernel.org
From: Lutz Vieweg <lvml@5t9.de>
Subject: Can I get a checksum for a file from btrfs (without reading the whole
 file)?
Date: Thu, 05 Feb 2015 11:40:10 +0100
Message-ID: <mavhab$f8m$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

use case: You have two huge files on a btrfs, you assume they contain the same bytes,
but you do not know for sure.

Is there a way to get a checksum of both files from btrfs with less effort than
reading the whole of both files and computing a hash sum?

(I was thinking that the btrfs-internal CRCs might be of use, here...)

Regards,

Lutz Vieweg

