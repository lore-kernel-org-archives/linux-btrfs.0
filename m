Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:60283 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab2GDQiC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jul 2012 12:38:02 -0400
Received: from [172.24.1.213] (unknown [192.166.201.94])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.in8.de (Postfix) with ESMTPSA id 7A5BF6AC270
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Jul 2012 18:38:00 +0200 (CEST)
Message-ID: <4FF47168.9010405@jan-o-sch.net>
Date: Wed, 04 Jul 2012 18:38:00 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
References: <20120702230121.GD12755@sli.dy.fi> <4FF2EF68.6090401@jan-o-sch.net> <20120703135824.GA8908@sli.dy.fi> <4FF3032D.1010007@jan-o-sch.net> <20120703224756.GA21647@sli.dy.fi> <20120704001713.GA8986@sli.dy.fi> <4FF42876.8010309@jan-o-sch.net> <20120704160340.GA9770@sli.dy.fi>
In-Reply-To: <20120704160340.GA9770@sli.dy.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04.07.2012 18:03, Sami Liedes wrote:
> Here you go.
> 
> 	Sami
> [...]
> [  200.980496] btrfs: invalid parameters for read_extent_buffer: start (32771) > eb->len (32768). eb start is 2243489562624, level 26, generation 3144240307695375391, nritems 620178657. len param 17. debug 2/989/620178657/3144240307695375391

Wow, that's strange. Can you repeat your test once or twice and paste that line,
please? I'd like to get a feeling if the values are completely random.

Reading more of the readahead code now...

Thanks,
-Jan
