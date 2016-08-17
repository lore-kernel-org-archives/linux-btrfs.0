Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:54050 "EHLO
	resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224AbcHQAOv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Aug 2016 20:14:51 -0400
Date: Tue, 16 Aug 2016 19:09:35 -0500
From: Tim Walberg <twalberg@comcast.net>
To: Rakesh Sankeshi <rakesh.sankeshi@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs quota issues
Message-ID: <20160817000935.GF2367@comcast.net>
Reply-To: Tim Walberg <twalberg@comcast.net>
References: <CAGj_d3D2OZt2nY622rp9NzxgAfKZ2iN1kLSQ2Ras-0fM+1+-ig@mail.gmail.com>
 <fe8222d8-6463-8b4d-0613-b3639455463d@cn.fujitsu.com>
 <CAGj_d3C1nf3LGCXfWxoYNpWP2X81v-+eT22yBx17HgfMaP7ocg@mail.gmail.com>
 <4a941169-1845-ba0e-6102-39920e1364b9@cn.fujitsu.com>
 <CAGj_d3C4=M7ZTvDhn+twROnf1qO4u-UXBmbP8HVQgfGiD91W6w@mail.gmail.com>
 <CAGj_d3C9274iWJN4vqPLamsEeO+ndPcnSefD-q-PA63ToeLBrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGj_d3C9274iWJN4vqPLamsEeO+ndPcnSefD-q-PA63ToeLBrw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/16/2016 16:33 -0700, Rakesh Sankeshi wrote:
>>	also is there any timeframe on when the qgroup / quota issues would be
>>	stabilized in btrfs?
>>	
>>	Thanks!

This may or may not be of interest to you, but for the record, since at least
linux 4.2, I've had pretty good luck with what I'd loosely call "non-enforcing
quotas" with btrfs - i.e. qgroups enabled so that you can actually track usage,
but no limits set, so none of the "deny allocation" logic ever gets hit. It's
understandably not the desired end-state - I still have to use daily reports
and manual enforcement to keep things in balance, but it's better than not
being able to use them at all, especially with the other benefits btrfs brings
to the table. If you really need the enforcement, I'm afraid a different FS
is the best option right now...



-- 
twalberg@gmail.com
