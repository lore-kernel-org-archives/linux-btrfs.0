Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:9111 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141AbaBXXfY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 18:35:24 -0500
Date: Tue, 25 Feb 2014 10:35:20 +1100
From: Dave Chinner <david@fromorbit.com>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests: add function _require_fssum()
Message-ID: <20140224233520.GT13647@dastard>
References: <1393242983-16149-1-git-send-email-fdmanana@gmail.com>
 <20140224122310.GO4317@dastard>
 <CAL3q7H5tfnb+uqa-ru5YNcok1n8PQxxai7UfkH-YgCdts84Tew@mail.gmail.com>
 <20140224222216.GP4317@dastard>
 <CAL3q7H7N3VVrfoVvNx_4wPsP38FO=sLNCBC-VJ2Tsz4NLqh39A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H7N3VVrfoVvNx_4wPsP38FO=sLNCBC-VJ2Tsz4NLqh39A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 24, 2014 at 11:08:27PM +0000, Filipe David Manana wrote:
> On Mon, Feb 24, 2014 at 10:22 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Feb 24, 2014 at 01:22:36PM +0000, Filipe David Manana wrote:
> >> On Mon, Feb 24, 2014 at 12:23 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> >> diff --git a/tests/btrfs/007 b/tests/btrfs/007
> >> >> index 5df9ccb..5430613 100755
> >> >> --- a/tests/btrfs/007
> >> >> +++ b/tests/btrfs/007
> >> >> @@ -31,7 +31,6 @@ seq=`basename $0`
> >> >>  seqres=$RESULT_DIR/$seq
> >> >>  echo "QA output created by $seq"
> >> >>
> >> >> -here=`pwd`
> >> >>  tmp=`mktemp -d`
> >> >>  status=1
> >> >
> >> > Yeah, redefining $here is a bad thing to do :/
> >
> > Right, my mistake. It needs to be defined for the entire test, not
> > in a requires function. Hence I think we should just export it from
> > check....
> 
> Hum, ok. So the decision is to let the tests explicitly define the
> variable "here", and not export "here" from the main check script.

Well, that's the status quo right now.

What I'm suggesting is that we should just export it from check and
get rid of it from each test as a separate cleanup. i.e. It always
needs to be set to the same value (i.e. the root of the xfstests
tree) so there is no reason why it should not be set up once in a
central location.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
