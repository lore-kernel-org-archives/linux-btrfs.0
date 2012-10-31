Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from loup.kjorling.se ([87.237.208.114]:51849 "EHLO loup.kjorling.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756867Ab2JaL5E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 07:57:04 -0400
Date: Wed, 31 Oct 2012 11:56:39 +0000
From: Michael =?utf-8?B?S2rDtnJsaW5n?= <michael@kjorling.se>
To: cwillu <cwillu@cwillu.com>
Cc: Ahmet Inan <ainan@mathematik.uni-freiburg.de>, linux-btrfs@vger.kernel.org
Subject: Re: Why btrfs inline small file by default?
Message-ID: <20121031115639.GB26070@yeono.kjorling.se>
References: <CAE5mzvhkrV9XD3_X_w_eLk7R4jrf4PxhEBJYTU7Hr6YtFDDd6Q@mail.gmail.com>
 <50904949.8010603@gmail.com>
 <20121030221412.GB11422@carfax.org.uk>
 <20121030221947.GC11422@carfax.org.uk>
 <50906702.1010608@gmail.com>
 <CAE5mzvgMskhBgH506BageXREifs63Zn_HKDaWBMuesS8Np66SQ@mail.gmail.com>
 <CAFDW0j+1wx2_ZewQ69W7fyLuMyYxq29g62FGH5uX9kAFv-H3eQ@mail.gmail.com>
 <CAE5mzvgRqTC+zismMUt0AOYWP52EN9taowARqU=he1cmVMSTEQ@mail.gmail.com>
 <CAFDW0jLGFwrg-9GDoBUxHa6M0ZgjB4W4GJg3b88+6L-dGLJMUw@mail.gmail.com>
 <CAE5mzvjc2EfZ-+P55PukWmM7EduOdBephnuBGAe2JPKuOiQ0vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAE5mzvjc2EfZ-+P55PukWmM7EduOdBephnuBGAe2JPKuOiQ0vg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 31 Oct 2012 04:57 -0600, from cwillu@cwillu.com (cwillu):
> 9.08GB + 992.48MB*2 == 11.02GB
> 
> 10.85GB + 518MB*2 == 11.86GB
> 
> That's nearly a GB smaller.

That, too; I missed the "DUP". Not quite as pronounced as in my
calculations, then, but still a significant enough difference.

-- 
Michael Kjörling • http://michael.kjorling.se • michael@kjorling.se
                “People who think they know everything really annoy
                those of us who know we don’t.” (Bjarne Stroustrup)
