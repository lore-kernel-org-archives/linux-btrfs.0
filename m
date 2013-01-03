Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from blu0-omc1-s3.blu0.hotmail.com ([65.55.116.14]:25787 "EHLO
	blu0-omc1-s3.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753035Ab3ACPbb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Jan 2013 10:31:31 -0500
Message-ID: <BLU0-SMTP213444C7DD70FB0E7A8EB63D5210@phx.gbl>
Date: Thu, 3 Jan 2013 17:25:20 +0200
From: Georgios Tsalikis <anaphaxeton@hol.gr>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Libified btrfs utils?
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is it possible that you deliver btrfs management utilities come in a C 
library form? It is always good to have a C API and CLI utility 
separation. Take libparted as an example. How much more functionality is 
in gparted than the (standard) cli parted? Writting tools by direct 
access to an API is much more elegant for a programmer. Please, consider 
my suggestion. Many would appreciate it, i am sure... Especially people 
like me that want to write GUI frontends.

Best regards,
Georgios Tsalikis
