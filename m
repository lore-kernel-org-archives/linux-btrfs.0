From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Wed, 31 Aug 2011 10:35:08 +1000
Message-ID: <20110831003508.GW3162@dastard>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
 <4E4F814B.5070202@gmail.com>
 <4E4F865B.2010608@gmail.com>
 <4E4FD48B.8030101@oracle.com>
 <4E4FE1B1.7010601@gmail.com>
 <4E51F24F.1050503@oracle.com>
 <CANGUGtCi85Sgrr5R0E8iuN75ubbMX9txZMwnsvp4Wv3Xh+938g@mail.gmail.com>
 <4E527C7F.9040807@oracle.com>
 <4E52984F.8050702@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com, viro@zeniv.linux.org.uk
To: Marco Stornelli <marco.stornelli@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4E52984F.8050702@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 22, 2011 at 07:56:31PM +0200, Marco Stornelli wrote:
> Il 22/08/2011 17:57, Sunil Mushran ha scritto:
> >>>Any proposal that differentiates between holes is wrong. It should not
> >>>matter where the hole is.
> >>>
> >>>Think of it from the usage-pov.
> >>>
> >>>doff = 0;
> >>>while ((doff = lseek(SEEK_DATA, doff)) != -ENXIO) {
> >>>hoff = lseek(SEEK_HOLE, doff);
> >>>read_offset = doff;
> >>>read_len = hoff -doff;
> >>>process();
> >>>doff = hoff;
> >>>}
> >>>
> >>>The goal is to make this as efficient as follows. Treating the last
> >>>hole differently adds more code for no benefit.
> >>>
> >>Mmmm.....It seems that Josef has to be clear in this point. However I
> >>looked for the seek hole test in xfs test suite, but I didn't find
> >>anything. Btrfs guys, how have you got tested the implementation? What
> >>do you think about this corner case? Al, what do you think about it?
> >
> >
> >The following test was used to test the early implementations.
> >http://oss.oracle.com/~smushran/seek_data/
> >
> 
> Thank you very much!! I found another point. Your test fails with my
> implementation because here
> (http://www.austingroupbugs.net/view.php?id=415) says: "If whence is
> SEEK_DATA, the file offset shall be set to the smallest location of
> a byte not within a hole and not less than offset. It shall be an
> error if no such byte exists." So in this case I return ENXIO but
> the test expects another value. I have to say that there is a bit of
> confusion about the real behavior of this new feature :)

Which is exactly why I'm trying to get the definitions clarified
first, then the behaviour codified in a single test suite we can
call the 'authoritive test'.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
