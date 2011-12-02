From: Chris Samuel <chris@csamuel.org>
Subject: Re: btrfs and load (sys)
Date: Fri, 02 Dec 2011 15:27:58 +1100
Message-ID: <4ED853CE.50200@csamuel.org>
References: <CAJ1PRSnhqo3yU4b0sbcYLfByb_pTDuAOL2xo4fryiEoacr8iYg@mail.gmail.com>	<4ECD26F0.501@cfl.rr.com> <CAJ1PRS=GGMtAsNaLyvOWL-nuRr6x1e2pj56hDqZWDFo60yNm9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ1PRS=GGMtAsNaLyvOWL-nuRr6x1e2pj56hDqZWDFo60yNm9Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/12/11 15:14, krzf83@gmail.com wrote:

> I've upgraded to newest kernel 3.1.2 but problem is not fixed. 

As btrfs is an experimental filesystem I don't believe that fixes are
backported to those stable releases, they only go into Linus's tree for
his next release (3.2 in this case).  So I'm afraid if you want to pick
up fixes as they appear you'll need to track Linus's tree really (or one
of Chris's).

I guess once btrfs is stable then that'll start to happen, but for the
moment I get the feeling that fixes and features are so tightly
entangled that it would be an awful lot of work to backport them to the
older code in the last stable release.

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
