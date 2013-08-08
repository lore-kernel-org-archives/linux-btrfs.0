Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:61222 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965133Ab3HHLEE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Aug 2013 07:04:04 -0400
Message-ID: <52037B21.3080303@giantdisaster.de>
Date: Thu, 08 Aug 2013 13:04:01 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-progs: drop weird indirections & dead code from send/receive
References: <51FC5BE7.2080506@redhat.com>
In-Reply-To: <51FC5BE7.2080506@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 02 Aug 2013 20:24:55 -0500, Eric Sandeen wrote:
> cmds-recieve.c & cmds-send.c seem to have weird wrappers and
> indirections, and "groups" of commands which have only
> one member, which are never referenced in the code.
> 
> I think these can be removed.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
>  cmds-receive.c |   19 +------------------
>  cmds-send.c    |   12 +-----------
>  commands.h     |    2 --
>  3 files changed, 2 insertions(+), 31 deletions(-)
> 
> Stefan, I'd appreciate your review & testing of this though!
> TBH it's an old patch I had laying around, but I have
> not re-tested it recently.

Reviewed & tested without issues.


> diff --git a/cmds-receive.c b/cmds-receive.c
> index 4e480f9..7abce76 100644
> --- a/cmds-receive.c
> +++ b/cmds-receive.c
> @@ -907,7 +907,7 @@ out:
>  	return ret;
>  }
>  
> -static int do_cmd_receive(int argc, char **argv)
> +int cmd_receive(int argc, char **argv)
>  {
>  	int c;
>  	char *tomnt = NULL;
> @@ -960,11 +960,6 @@ static int do_cmd_receive(int argc, char **argv)
>  	return ret;
>  }
>  
> -static const char * const receive_cmd_group_usage[] = {
> -	"btrfs receive <command> <args>",
> -	NULL
> -};
> -
>  const char * const cmd_receive_usage[] = {
>  	"btrfs receive [-ve] [-f <infile>] <mount>",
>  	"Receive subvolumes from stdin.",
> @@ -988,15 +983,3 @@ const char * const cmd_receive_usage[] = {
>  	"                 is recognized or on EOF.",
>  	NULL
>  };
> -
> -const struct cmd_group receive_cmd_group = {
> -	receive_cmd_group_usage, NULL, {
> -		{ "receive", do_cmd_receive, cmd_receive_usage, NULL, 0 },
> -		{ 0, 0, 0, 0, 0 },
> -        },
> -};
> -
> -int cmd_receive(int argc, char **argv)
> -{
> -	return do_cmd_receive(argc, argv);
> -}
> diff --git a/cmds-send.c b/cmds-send.c
> index 7209aba..f9899f4 100644
> --- a/cmds-send.c
> +++ b/cmds-send.c
> @@ -465,7 +465,7 @@ out:
>  	return ret;
>  }
>  
> -int cmd_send_start(int argc, char **argv)
> +int cmd_send(int argc, char **argv)
>  {
>  	char *subvol = NULL;
>  	int c;
> @@ -718,11 +718,6 @@ out:
>  	return ret;
>  }
>  
> -static const char * const send_cmd_group_usage[] = {
> -	"btrfs send <command> <args>",
> -	NULL
> -};
> -
>  const char * const cmd_send_usage[] = {
>  	"btrfs send [-ve] [-p <parent>] [-c <clone-src>] <subvol>",
>  	"Send the subvolume to stdout.",
> @@ -750,8 +745,3 @@ const char * const cmd_send_usage[] = {
>  	"                 use pipes.",
>  	NULL
>  };
> -
> -int cmd_send(int argc, char **argv)
> -{
> -	return cmd_send_start(argc, argv);
> -}
> diff --git a/commands.h b/commands.h
> index 65829f4..3f12fab 100644
> --- a/commands.h
> +++ b/commands.h
> @@ -85,8 +85,6 @@ extern const struct cmd_group balance_cmd_group;
>  extern const struct cmd_group device_cmd_group;
>  extern const struct cmd_group scrub_cmd_group;
>  extern const struct cmd_group inspect_cmd_group;
> -extern const struct cmd_group send_cmd_group;
> -extern const struct cmd_group receive_cmd_group;
>  extern const struct cmd_group quota_cmd_group;
>  extern const struct cmd_group qgroup_cmd_group;
>  extern const struct cmd_group replace_cmd_group;
> 

