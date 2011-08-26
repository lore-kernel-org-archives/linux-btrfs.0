From: Arne Jansen <sensille@gmx.net>
Subject: Re: BTRFS and power loss ~= corruption?
Date: Fri, 26 Aug 2011 11:30:53 +0200
Message-ID: <4E5767CD.3010407@gmx.net>
References: <4E54F884.9090004@cyberwizzard.nl>	<CAAS2fgRfW3J441Xv8x6cnKWyKGao-ZGi4_Od=iB-fLX3YixV5g@mail.gmail.com>	<4E573F1A.2060807@gmx.net> <CAMU1PDgk-uKU9SuQz1YxGPNVy3HVObwtYALgcDL_Jb0MWcss5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Mike Fleetwood <mike.fleetwood@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAMU1PDgk-uKU9SuQz1YxGPNVy3HVObwtYALgcDL_Jb0MWcss5w@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 26.08.2011 09:48, Mike Fleetwood wrote:
>> On 26.08.2011 01:01, Gregory Maxwell wrote:
> 
> This article describes evaluating ext3, reiserfs and jfs using fault
> injection using a custom Linux block device driver.
> "Model-Based Failure Analysis of Journaling File Systems"
> http://www.cs.wisc.edu/adsl/Publications/sfa-dsn05.pdf
> --

While the article is interesting, it describes a quite different
failure mode. I/O-error handling is not very sophisticated in
btrfs yet. The tests Gregory were taking about are on completely
well-behaving hardware. Failure injection would be the second step.
