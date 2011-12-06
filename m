From: Jan Schmidt <mail@jan-o-sch.net>
Subject: Re: [PATCH] xfstests: check if qa user can execute commands
Date: Tue, 06 Dec 2011 16:16:45 +0100
Message-ID: <4EDE31DD.3000401@jan-o-sch.net>
References: <1323165389-5419-1-git-send-email-list.btrfs@jan-o-sch.net> <20111206151300.GA11874@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111206151300.GA11874@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 06.12.2011 16:13, Christoph Hellwig wrote:
> On Tue, Dec 06, 2011 at 10:56:29AM +0100, Jan Schmidt wrote:
>> _require_user only checks if the qa user exists in /etc/passwd. It may exist
>> though still not be able to execute anything (e.g. with a /bin/false shell).
>>
>> _user_do cannot determine failure to execute the given command, as it uses
>> _user_do_filter for post-processing which succeeds even if the command
>> fails. Thus, the check should be performed by _require_user.
> 
> Looks good.  Wouldn't
> 
> 	su $qa_user -c /bin/true
> 
> be the more normal way to write that test?

I agree. I saw this and thought I'd adapt the (sometimes strange)
predominant bash programming style:

 921 _user_do()
 922 {
 923     if [ "$HOSTOS" == "IRIX" ]
 924         then
 925         echo $1 | /bin/bash "su $qa_user 2>&1" | _filter_user_do
 926     else
 927         echo $1 | su $qa_user 2>&1 | _filter_user_do
 928     fi
 929 }

-Jan
