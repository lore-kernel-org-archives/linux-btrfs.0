Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30777 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756864Ab3HGDEj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Aug 2013 23:04:39 -0400
Message-ID: <5201BA9A.8010003@oracle.com>
Date: Wed, 07 Aug 2013 11:10:18 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: introduce command namespace for development
 features
References: <cover.1375791411.git.dsterba@suse.cz> <79debec8a345c66dd0b02793de680e0438428ee0.1375791411.git.dsterba@suse.cz> <20130806180137.GM12314@lenny.home.zabbo.net>
In-Reply-To: <20130806180137.GM12314@lenny.home.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  Further there is benefit of having newer subcommands
  in the master branch - it gets visibility.

  However if we are trying to solve the problem of it
  not being end user ready then there can be a warning
  message about it when the user uses it or sees it.

  I see some of online shops tagging new problem with
  bright red "New" on the product image. Could we have
  some "warning" shown against these new subcommands ?

  just my 1c.

Anand


On 08/07/2013 02:01 AM, Zach Brown wrote:
> On Tue, Aug 06, 2013 at 02:25:20PM +0200, David Sterba wrote:
>> We'd like to make it easier to preview a new feature and remove the
>> burden to invent sane user interface (command name, placement,
>> arguments, man) from the beginning.
>
> My biggest worry about this is that it complicates the coordination of
> automated testing, which is already in a terrible state for btrfs-progs.
> It can't possibly motivate people to write tests if we make the process
> more cumbersome than it already is.
>
> So we develop tests for a command (maybe in xfstests,  maybe in
> btrfs-progs) that use this magical _ namespace.  Then the command is
> merged.  When are the tests updated?  Do they fallback to both so that
> the tests can work across the merge?   Do we add some complexity to try
> and magically match _ commands that aren't found with matching commands
> somewhere else in the heirarchy?  Ugh, all 'round.
>
> I'm not sure I understand what problem this is really solving.  People
> shouldn't be expecting to find incomplete features in the master branch,
> right?  If people are looking to test incomplete work they can get your
> integration branch and, well, we don't care if it changes later?
>
> - z
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
