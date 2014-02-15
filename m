Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:48717 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689AbaBOW3S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Feb 2014 17:29:18 -0500
Date: Sun, 16 Feb 2014 09:29:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, dsterba@suse.cz,
        Koen De Wit <koen.de.wit@oracle.com>, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: test for atime-related mount options
Message-ID: <20140215222915.GU13647@dastard>
References: <1392305016-7424-1-git-send-email-koen.de.wit@oracle.com>
 <52FCF60F.6030703@sandeen.net>
 <20140214163925.GW16073@twin.jikos.cz>
 <52FE472C.8070503@sandeen.net>
 <20140214222418.GT13997@dastard>
 <52FEAB6B.10107@redhat.com>
 <20140215013931.GT13647@dastard>
 <52FED8B0.6040009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52FED8B0.6040009@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 14, 2014 at 09:02:08PM -0600, Eric Sandeen wrote:
> On 2/14/14, 7:39 PM, Dave Chinner wrote:
> > On Fri, Feb 14, 2014 at 05:48:59PM -0600, Eric Sandeen wrote:
> >> On 2/14/14, 4:24 PM, Dave Chinner wrote:
> >>> On Fri, Feb 14, 2014 at 10:41:16AM -0600, Eric Sandeen wrote:
> >>>> On 2/14/14, 10:39 AM, David Sterba wrote:
> >>>>> On Thu, Feb 13, 2014 at 10:42:55AM -0600, Eric Sandeen wrote:
> >>>>>>> +cat /proc/mounts | grep "$SCRATCH_MNT" | grep relatime >> $seqres.full
> >>>>>>> +[ $? -ne 0 ] && echo "The relatime mount option should be the default."
> >>>>>>
> >>>>>> Ok, I guess "relatime" in /proc/mounts is from core vfs code and
> >>>>>> should be there for the foreseeable future, so seems ok.
> >>>>>>
> >>>>>> But - relatime was added in v2.6.20, and made default in 2.6.30.  So
> >>>>>> testing older kernels may not go as expected; it'd probably be best to
> >>>>>> catch situations where relatime isn't available (< 2.6.20) or not
> >>>>>> default (< 2.6.30), by explicitly mounting with relatime, and skipping
> >>>>>> relatime/strictatime tests if that fails?
> >>>>>
> >>>>> Is there some consensus what's the lowest kernel version to be supported
> >>>>> by xfstests? 2.6.32 is the lowest base for kernels in use today, so
> >>>>> worrying about anything older does not seem necessary.
> >>>>>
> >>>>
> >>>> I don't know that it's been discussed - selfishly, I know our QE uses
> >>>> xfstests on RHEL5, which is 2.6.18-based.
> >>>
> >>> Sure, but they can just add the test to a "rhel5-expunged" file and
> >>> they don't have to care about tests that won't work on RHEL 5 or
> >>> other older kernels. Or to send patches to add "_requires_relatime"
> >>> so that it automatically does the right thing for older kernels.
> >>
> >> sure but some of this test is still valid on a kernel w/o relatime.
> >> And since it's the default, "relatime" might disappear from /proc/mounts
> >> some day anyway, so explicitly mounting with the option & failing
> >> if that fails might be good future-proofind in any case.
> >>
> >> *shrug*
> >>
> >> It was just a request, not a demand.  :)  Koen, you can do with
> >> it whatever you like.  Reviews aren't ultimatums.  :)
> >>
> >> If xfstests upstream is only targeted at the current kernel, that's
> >> fine, but maye we should make that a little more explicit.
> > 
> > That's not what I meant. ;)
> > 
> > Really, all I'm saying is that we can't expect people who are
> > writing tests that work on current kernels to know what is necessary
> > to make tests work on 7 year old distros that don't support a
> > feature that has been in mainline for 5 years. Hence that shouldn't
> > be a barrier to having a test committed as we have mechanisms for
> > distro QE to handle these sorts of issues...
> 
> Sure, that's perfectly fair.
> 
> I wasn't really thinking of RHEL5 when I made my first comment,
> just general portability across kernels.  dsterba suggested that
> 2.6.32 is the oldest kernel used, and I pointed out that we do
> still use 2.6.18.  :)
> 
> Anyway, for general portability across releases, perhaps rather than:
> 
> +cat /proc/mounts | grep "$SCRATCH_MNT" | grep relatime >> $seqres.full
> +[ $? -ne 0 ] && echo "The relatime mount option should be the default."
> 
> which would fail the test, it should just [notrun] if relatime
> isn't there, for any reason, on any kernel, if relatime is not
> default as expected for the test framework.  i.e.
> 
> +[ $? -ne 0 ] && _notrun "The relatime mount option is not the default."

I disagree - the test doesn't need to care what the default mount
option is - it's a relatively silly thing to test because it doesn't
determine whether the behaviour of the option is correct or not.
Especially as the test is checking the behaviour of specific atime
mount options so it should just specify each one it is testing and
ignoring what the default is. IOWs, the default atime behaviour just
doesn't matter for the purpose of the test....

What the test actually cares about is this:

_require_relatime()
{
	_scratch_mkfs > /dev/null 2>&1
	_mount -t $FSTYP -o relatime $SCRATCH_DEV $SCRATCH_MNT || \
		_notrun "relatime not supported by the current kernel"
}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
