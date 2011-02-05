From: cwillu <cwillu@cwillu.com>
Subject: Re: Suggestion for sticky-compression mount setting (default mount options)
Date: Sat, 5 Feb 2011 09:31:24 -0600
Message-ID: <AANLkTik78DfZbXcztFuNOixwmRB1Prr00E7C7XT7eyAz@mail.gmail.com>
References: <1296873843.7800.36.camel@KWOLFF03>
	<20110205131846.0000748c@unknown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Kirk Wolff <kirk@wolffelectronicdesign.com>,
	linux-btrfs@vger.kernel.org
To: Felix Blanke <felixblanke@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110205131846.0000748c@unknown>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 5, 2011 at 6:18 AM, Felix Blanke <felixblanke@gmail.com> wrote:
> Hi,
>
> I don't think that the fs is a good place to store default mountoptions.
>
> If you want to auto mount usb devices with compression, just write a
> udev rule or whatever ubuntu uses to mount usb devices.

I believe the point was to avoid configuring each system he might use
it with; otherwise a simple fstab entry would have sufficed.
