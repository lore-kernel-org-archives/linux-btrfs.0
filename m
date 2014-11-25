Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49109 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbaKYSJT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 13:09:19 -0500
Date: Tue, 25 Nov 2014 19:09:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Silvio Fricke <silvio.fricke@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: add task-utils
Message-ID: <20141125180918.GN26471@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1415549388.git.silvio.fricke@gmail.com>
 <ffe2360627753d1ed45a04e5099dff20741d4b4a.1415571118.git.silvio.fricke@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ffe2360627753d1ed45a04e5099dff20741d4b4a.1415571118.git.silvio.fricke@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

so started reviewing the patches for inclusion in the 3.18 branch and
found a few things that I've fixed locally, this is just FYI.

On Sun, Nov 09, 2014 at 11:16:55PM +0100, Silvio Fricke wrote:
> Signed-off-by: Silvio Fricke <silvio.fricke@gmail.com>
> ---
>  task-util.c | 121 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  task-util.h |  33 +++++++++++++++++
>  2 files changed, 154 insertions(+)
>  create mode 100644 task-util.c
>  create mode 100644 task-util.h
> 
> diff --git a/task-util.c b/task-util.c
> new file mode 100644
> index 0000000..9268df7
> --- /dev/null
> +++ b/task-util.c

Renamed the file to task-utils.c

> diff --git a/task-util.h b/task-util.h
> new file mode 100644
> index 0000000..95f7b5b
> --- /dev/null
> +++ b/task-util.h
> @@ -0,0 +1,33 @@
> +
> +#ifndef __PROGRESS_
> +#define __PROGRESS_

__TASK_UTILS_H__

> +
> +#include <pthread.h>
> +
> +struct periodic_info {
> +	int timer_fd;
> +	unsigned long long wakeups_missed;
> +};
> +
> +struct task_info {
> +	struct periodic_info periodic;
> +	pthread_t id;
> +	void *private_data;
> +	void *(*threadfn)(void *);
> +	int (*postfn)(void *);
> +};
> +
> +/* task life cycle */
> +struct task_info *task_init(void *(*threadfn)(void *), int (*postfn)(void *),
> +			    void *thread_private);
> +int task_start(struct task_info *info);
> +void task_stop(struct task_info *info);
> +void task_deinit(struct task_info *info);
> +
> +/* periodic life cycle */
> +int task_period_start(struct task_info *info, unsigned int period_ms);
> +void task_period_wait(struct task_info *info);
> +void task_period_stop(struct task_info *info);
> +
> +#endif /* __PROGRESS_ */

dtto
