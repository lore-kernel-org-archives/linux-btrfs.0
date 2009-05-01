From: Dmitri Nikulin <dnikulin@gmail.com>
Subject: Re: kernel bug in file-item.c
Date: Fri, 1 May 2009 12:13:30 +1000
Message-ID: <3a7f57190904301913u2d503a96yc7b4c02083736d9f@mail.gmail.com>
References: <49F73F69.4010205@oel.state.nj.us>
	 <49F87A7F.7090804@oel.state.nj.us>
	 <1241027618.20099.48.camel@think.oraclecorp.com>
	 <49F89AB4.2090001@oel.state.nj.us>
	 <1241029841.20099.53.camel@think.oraclecorp.com>
	 <49F89E91.3020604@oel.state.nj.us>
	 <1241030419.20099.55.camel@think.oraclecorp.com>
	 <20090429193207.GK26602@tracyreed.org>
	 <715ea5c10904300208l5c0ac6f1ma07f96b662304c4a@mail.gmail.com>
	 <20090430165404.GB4657@tracyreed.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090430165404.GB4657@tracyreed.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 1, 2009 at 2:54 AM, Tracy Reed <treed@ultraviolet.org> wrote:
> Sorry, I was unclear: I meant manage in a public-relations sort of
> way. Not in a technical way. You are absolutely right that bad RAM or
> CPU means you are hosed.

Even so, it's a perfect opportunity to not make things worse by trying
to write data after fundamental assertions have already failed. My
most recent data loss scenario with ext3 involved a little
kernel/hardware/whatever glitch that would have been harmless on its
own, but ext3 took as a cue to completely mangle metadata. I found XML
config files with PNG blocks in them, etc.

-- 
Dmitri Nikulin

Centre for Synchrotron Science
Monash University
Victoria 3800, Australia
