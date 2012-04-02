From: David Sterba <dave@jikos.cz>
Subject: Re: cross-subvolume cp --reflink
Date: Mon, 2 Apr 2012 10:29:23 +0200
Message-ID: <20120402082923.GB14256@twin.jikos.cz>
References: <20120401152749.61790@gmx.net> <4F787485.202@gmail.com> <20120401164136.61800@gmx.net> <4F788619.1040403@gmail.com> <20120401170754.238550@gmx.net> <4F788EE2.4010105@univie.ac.at> <20120401183912.61760@gmx.net> <4F78AC2A.8050408@gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Norbert Scheibner <scno@gmx.net>,
	"Klaus A. Kreil" <klaus.kreil@univie.ac.at>,
	linux-btrfs@vger.kernel.org
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F78AC2A.8050408@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 01, 2012 at 10:27:38PM +0300, Konstantinos Skarlatos wrote:
> thats true, cp --reflink is much better. Also am I wrong that btrfs has 
> a limitation on the number of hard links that can only be fixed with a 
> disk format change?

There's patch in development to lift the limit and it does not need the
disk format change but adds an incompatibility bit.


david
