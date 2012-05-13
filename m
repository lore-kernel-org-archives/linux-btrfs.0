From: Avi Kivity <avi.kivity@gmail.com>
Subject: Re: Problems with nodatacow/nodatasum
Date: Sun, 13 May 2012 20:51:53 +0300
Message-ID: <CAEbWairER0P4eA299E7vizH5ZA-nHPv0ze8V_LF8dd=bPPgByQ@mail.gmail.com>
References: <CAEbWaipj_MzfM2wF6CpQg5dNCmLNLVomReDmnBVZHv9R3Be-cw@mail.gmail.com>
	<20120420091250.GK20982@twin.jikos.cz>
	<CAEbWaiqfh9KBM5U0QtqULHwLed854MeY=cPSxWRhoEGND9ve0A@mail.gmail.com>
	<20120421001551.GL30599@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Avi Kivity <avi.kivity@gmail.com>, dave@jikos.cz,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120421001551.GL30599@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 21, 2012 at 3:15 AM, Chris Mason <chris.mason@oracle.com> wrote:
>>
>> Are there plans to allow per-subvolume nodatasum/nodatacow?
>
> It can be set on a per file basis, let me push out a commit to btrfs
> progs with ioctls to set it.

Did this not happen, or am I barking up the wrong btrfs-progs.git tree?
