From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] BTRFS: Free inode mutex on lseek error
Date: Sat, 20 Aug 2011 09:43:01 -0400
Message-ID: <20110820134301.GA8266@dhcp231-156.rdu.redhat.com>
References: <1313798858-10938-1-git-send-email-andi@firstfloor.org> <4E4FA3B9.6000203@redhat.com> <20110820125317.GJ25996@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
	chris.mason@oracle.com
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110820125317.GJ25996@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 20, 2011 at 02:53:17PM +0200, Andi Kleen wrote:
> On Sat, Aug 20, 2011 at 08:08:25AM -0400, Josef Bacik wrote:
> > On 08/19/2011 08:07 PM, Andi Kleen wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > Introduced with b26751575a9aa55fd6dbf3febde3ff06dfadc44f
> > > 
> > 
> > This has already been fixed by
> > 
> > 9a4327ca1f45f82edad7dc0a4e52ce9316e0950c
> 
> It's not. That patch returns the wrong return value.
>

Oh duh I see, sorry,

Josef 
