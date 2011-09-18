From: Chris Samuel <chris@csamuel.org>
Subject: Re: btrfs vs data deduplication
Date: Mon, 19 Sep 2011 08:14:02 +1000
Message-ID: <1316384042.2249.2.camel@Nokia-N900>
References: <CACVpCE7ZSjgT9+h2DfHAR_n=4LqHguOSVaNzE3YcnZ5Bb00_Kw@mail.gmail.com>
	  <201109182215.58477.hubert@kario.pl>
Reply-To: Chris Samuel <chris@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201109182215.58477.hubert@kario.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 19 Sep 2011, 06:15:51 EST, Hubert Kario <hubert@kario.pl> wrote:

> You shouldn't depend on single drive, metadata
> raid is there to protect against single bad
> blocks, not disk crash.

I guess the issue here is you no longer even
have that protection with this sort of dedup.

cheers,
Chris
-- 
Chris Samuel - http://www.csamuel.org/
