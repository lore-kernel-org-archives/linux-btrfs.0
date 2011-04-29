From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] tracing: add __print_symbolic_u64 to avoid warnings
 on 32bit machine
Date: Fri, 29 Apr 2011 18:01:57 +0800
Message-ID: <4DBA8C95.4000300@cn.fujitsu.com>
References: <4D9573DB.4010009@cn.fujitsu.com>	 <1301665762.2160.22.camel@gandalf.stny.rr.com>	 <4D9C2FF6.7090607@cn.fujitsu.com> <1303150309.7181.51.camel@gandalf.stny.rr.com> <4DACE6E0.7000507@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DACE6E0.7000507@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

ping?

On 04/19/2011 09:35 AM, liubo wrote:
> Filesystem, like Btrfs, has some "ULL" macros, and when these macros are passed
> to tracepoints'__print_symbolic(), there will be 64->32 truncate WARNINGS during
> compiling on 32bit box.
> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>  include/linux/ftrace_event.h |   12 ++++++++++++
>  include/trace/ftrace.h       |   13 +++++++++++++
>  kernel/trace/trace_output.c  |   27 +++++++++++++++++++++++++++
>  3 files changed, 52 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 47e3997..efb2330 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -16,6 +16,11 @@ struct trace_print_flags {
>  	const char		*name;
>  };
>  
> +struct trace_print_flags_u64 {
> +	unsigned long long	mask;
> +	const char		*name;
> +};
> +
>  const char *ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
>  				   unsigned long flags,
>  				   const struct trace_print_flags *flag_array);
> @@ -23,6 +28,13 @@ const char *ftrace_print_flags_seq(struct trace_seq *p, const char *delim,
>  const char *ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
>  				     const struct trace_print_flags *symbol_array);
>  
> +#if BITS_PER_LONG == 32
> +const char *ftrace_print_symbols_seq_u64(struct trace_seq *p,
> +					 unsigned long long val,
> +					 const struct trace_print_flags_u64
> +								 *symbol_array);
> +#endif
> +
>  const char *ftrace_print_hex_seq(struct trace_seq *p,
>  				 const unsigned char *buf, int len);
>  
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 3e68366..533c49f 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -205,6 +205,19 @@
>  		ftrace_print_symbols_seq(p, value, symbols);		\
>  	})
>  
> +#undef __print_symbolic_u64
> +#if BITS_PER_LONG == 32
> +#define __print_symbolic_u64(value, symbol_array...)			\
> +	({								\
> +		static const struct trace_print_flags_u64 symbols[] =	\
> +			{ symbol_array, { -1, NULL } };			\
> +		ftrace_print_symbols_seq_u64(p, value, symbols);	\
> +	})
> +#else
> +#define __print_symbolic_u64(value, symbol_array...)			\
> +			__print_symbolic(value, symbol_array)
> +#endif
> +
>  #undef __print_hex
>  #define __print_hex(buf, buf_len) ftrace_print_hex_seq(p, buf, buf_len)
>  
> diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> index 02272ba..b783504 100644
> --- a/kernel/trace/trace_output.c
> +++ b/kernel/trace/trace_output.c
> @@ -353,6 +353,33 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned long val,
>  }
>  EXPORT_SYMBOL(ftrace_print_symbols_seq);
>  
> +#if BITS_PER_LONG == 32
> +const char *
> +ftrace_print_symbols_seq_u64(struct trace_seq *p, unsigned long long val,
> +			 const struct trace_print_flags_u64 *symbol_array)
> +{
> +	int i;
> +	const char *ret = p->buffer + p->len;
> +
> +	for (i = 0;  symbol_array[i].name; i++) {
> +
> +		if (val != symbol_array[i].mask)
> +			continue;
> +
> +		trace_seq_puts(p, symbol_array[i].name);
> +		break;
> +	}
> +
> +	if (!p->len)
> +		trace_seq_printf(p, "0x%llx", val);
> +
> +	trace_seq_putc(p, 0);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(ftrace_print_symbols_seq_u64);
> +#endif
> +
>  const char *
>  ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int buf_len)
>  {

